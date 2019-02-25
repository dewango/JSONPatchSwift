//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import Foundation

// swiftlint:disable nesting
struct JPSConstants {
    
    struct JsonPatch {
        
        struct Parameter {
            static let OpConst: String = "op"
            static let Path: String = "path"
            static let Value: String = "value"
            static let From: String = "from"
        }
        
        struct InitialisationErrorMessages {
            static let PatchEncoding: String = "Could not encode patch."
            static let PatchWithEmptyError: String = "Patch array does not contain elements."
            static let InvalidRootElement: String = "Root element is not an array of dictionaries or a single dictionary."
            static let OpElementNotFound: String = "Could not find 'op' element."
            static let PathElementNotFound: String = "Could not find 'path' element."
            static let InvalidOperation: String = "Operation is invalid."
            static let FromElementNotFound: String = "Could not find 'from' element."
            static let ValueElementNotFound: String = "Could not find 'value' element."
        }
        
        struct ErrorMessages {
            static let ValidationError: String = "Could not validate JSON."
        }
        
    }

    struct Operation {
        static let Add: String = "add"
        static let Remove: String = "remove"
        static let Replace: String = "replace"
        static let Move: String = "move"
        static let Copy: String = "copy"
        static let Test: String = "test"
    }
    
    struct JsonPointer {
        static let Delimiter: String = "/"
        static let EndOfArrayMarker: String = "-"
        static let EmptyString: String = ""
        static let EscapeCharater: String = "~"
        static let EscapedDelimiter: String = "~1"
        static let EscapedEscapeCharacter: String = "~0"
    }
    
}
