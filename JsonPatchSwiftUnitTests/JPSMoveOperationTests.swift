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

// http://tools.ietf.org/html/rfc6902#section-4.4
// 4.  Operations
// 4.4.  move
class JPSMoveOperationTests: XCTestCase {

    // http://tools.ietf.org/html/rfc6902#appendix-A.6
    func testIfMoveValueInObjectReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: ("{ \"foo\": { \"bar\": \"baz\","
            + " \"waldo\": \"fred\" }, \"qux\":{ \"corge\": \"grault\" } }").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/qux/thud\", \"from\": \"/foo/waldo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: (" { \"foo\": { \"bar\":"
            + " \"baz\" }, \"qux\": { \"corge\": \"grault\",\"thud\": \"fred\" } }").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    // http://tools.ietf.org/html/rfc6902#appendix-A.7
    func testIfMoveIndizesInArrayReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : [\"all\", \"grass\", \"cows\", \"eat\"]} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/foo/3\", \"from\": \"/foo/1\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: ("{ \"foo\" : [\"all\","
            + " \"cows\", \"eat\", \"grass\"]} ").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveOperationReturnsExpectedValue() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/bar/1\", \"from\": \"/foo/1\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"foo\" : {  }, \"bar\" : { \"1\" : 2 }}".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfObjectKeyMoveToRootReplacesDocument() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"move\", \"path\": \"\", \"from\": \"/foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"1\" : 2 }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfMissingParameterReturnsError() {
        do {
            let result: JPSJsonPatch = try JPSJsonPatch("{ \"op\": \"move\", \"path\": \"/bar\"}") // 'from' parameter missing
            XCTFail(result.operations.last!.value.rawString()!)
            // swiftlint:disable:next explicit_type_interface
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(message: let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }
}
