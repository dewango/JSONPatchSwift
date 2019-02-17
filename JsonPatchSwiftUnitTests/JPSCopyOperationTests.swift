//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// http://tools.ietf.org/html/rfc6902#section-4.5
// 4.  Operations
// 4.5. copy
class JPSCopyOperationTests: XCTestCase {
    
    func testIfCopyReplaceValueInObjectReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch  = try? JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { \"1\" : 2 }} ".data(
            using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)

    }

    func testIfCopyArrayReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : [1, 2, 3, 4], \"bar\" : []} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " { \"foo\" : [1, 2, 3, 4], \"bar\" : [1, 2, 3, 4]}".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfCopyArrayOfObjectsReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : [{\"foo\": \"bar\"}], \"bar\" : {} } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo/0\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: (" { \"foo\" "
            + ": [{\"foo\": \"bar\"}], \"bar\" : {\"foo\": \"bar\"}}").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfMissingParameterReturnsError() {
        do {
            let result: JPSJsonPatch = try JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\"}") // from parameter missing
            XCTFail(result.operations.last!.value.rawString()!)
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(message: let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

}
