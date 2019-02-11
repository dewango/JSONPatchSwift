//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import SwiftyJSON

func == (lhs: JPSJsonPatch, rhs: JPSJsonPatch) -> Bool {
    
    guard lhs.operations.count == rhs.operations.count else { return false }
    
    for index in 0..<lhs.operations.count where !(lhs.operations[index] == rhs.operations[index]) {
        return false
    }
    
    return true
}

/// Representation of a JSON Patch
public struct JPSJsonPatch {

    let operations: [JPSOperation]

    /**
     Initializes a new `JPSJsonPatch` based on a given SwiftyJSON representation.

     - Parameter _: A String representing one or many JSON Patch operations.
        e.g. (1) JSON({ "op": "add", "path": "/", "value": "foo" })
        or (> 1)
        JSON([ { "op": "add", "path": "/", "value": "foo" },
        { "op": "test", "path": "/", "value": "foo } ])

     - Throws: can throw any error from `JPSJsonPatch.JPSJsonPatchInitialisationError` to
        notify failed initialization.

     - Returns: a `JPSJsonPatch` representation of the given SwiftJSON object
    */
    public init(_ patch: JSON) throws {
        // Check if there is an array of a dictionary as root element. Both are valid JSON patch documents.
        if patch.dictionary != nil {
            self.operations = [try JPSJsonPatch.extractOperationFromJson(patch)]
            
        } else if patch.array != nil {
            guard 0 < patch.count else {
                throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.PatchWithEmptyError)
            }
            var operationArray = [JPSOperation]()
            for index in 0..<patch.count {
                let operation = patch[index]
                operationArray.append(try JPSJsonPatch.extractOperationFromJson(operation))
            }
            self.operations = operationArray
            
        } else {
            // All other types are not a valid JSON Patch Operation.
            throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.InvalidRootElement)
        }
    }

    /**
     Initializes a new `JPSJsonPatch` based on a given String representation.

     - parameter _: A String representing one or many JSON Patch operations.
        e.g. (1) { "op": "add", "path": "/", "value": "foo" }
        or (> 1)
        [ { "op": "add", "path": "/", "value": "foo" },
        { "op": "test", "path": "/", "value": "foo } ]

     - throws: can throw any error from `JPSJsonPatch.JPSJsonPatchInitialisationError` to notify failed initialization.

     - returns: a `JPSJsonPatch` representation of the given JSON Patch String.
     */
    public init(_ patch: String) throws {
        // Convert the String to NSData
        let data = patch.data(using: String.Encoding.utf8)!
        
        // Parse the JSON
        let json = try? JSON(data: data, options: .allowFragments)

        guard let unwrappedJSON = json else {
            throw JPSJsonPatchInitialisationError.invalidJsonFormat(message: "")
        }
        try self.init(unwrappedJSON)
    }

    /// Possible errors thrown by the init function.
    public enum JPSJsonPatchInitialisationError: Error {
        /** InvalidJsonFormat: The given String is not a valid JSON. */
        case invalidJsonFormat(message: String?)
        /** InvalidPatchFormat: The given Patch is invalid (e.g. missing mandatory parameters). See error message for details. */
        case invalidPatchFormat(message: String?)
    }
}


// MARK: - Private functions

extension JPSJsonPatch {
    
    fileprivate static func extractOperationFromJson(_ json: JSON) throws -> JPSOperation {
        
        // The elements 'op' and 'path' are mandatory.
        guard let operation = json[JPSConstants.JsonPatch.Parameter.Op].string else {
            throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.OpElementNotFound)
        }
        guard let path = json[JPSConstants.JsonPatch.Parameter.Path].string else {
            throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.PathElementNotFound)
        }
        guard let operationType = JPSOperation.JPSOperationType(rawValue: operation) else {
            throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.InvalidOperation)
        }

        // 'from' element mandatory for .Move, .Copy operations
        var from: JPSJsonPointer?
        if operationType == .move || operationType == .copy {
            guard let fromValue = json[JPSConstants.JsonPatch.Parameter.From].string else {
                throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
            }
            from = try JPSJsonPointer(rawValue: fromValue)
        }

        // 'value' element mandatory for .Add, .Replace operations
        let value = json[JPSConstants.JsonPatch.Parameter.Value]
        // counterintuitive null check: https://github.com/SwiftyJSON/SwiftyJSON/issues/205
        if (operationType == .add || operationType == .replace) && value.null != nil {
            throw JPSJsonPatchInitialisationError.invalidPatchFormat(message: JPSConstants.JsonPatch.InitialisationErrorMessages.ValueElementNotFound)
        }

        let pointer = try JPSJsonPointer(rawValue: path)
        return JPSOperation(type: operationType, pointer: pointer, value: value, from: from)
    }
    
}
