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

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// http://tools.ietf.org/html/rfc6902#section-4.6
// 4.  Operations
// 4.6. test
class JPSTestOperationTests: XCTestCase {

    func testIfBasicStringCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": \"2\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicStringCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": \"3\" }") else {
            XCTFail("json parse error")
            return
        }
        guard (try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)) != nil else {
            XCTFail("json parse error")
            return
        }
    }

    func testIfBasicIntCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": 2 }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicIntCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo/1\", \"value\": 3 }") else {
            XCTFail("json parse error")
            return
        }
        guard let _: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
    }

    func testIfBasicObjectCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : 2 }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": { \"1\" : 2 } }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicObjectCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : { \"1\" : \"2\" }} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": { \"1\" : 3 } }") else {
            XCTFail("json parse error")
            return
        }
        guard let _: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
    }

    func testIfBasicArrayCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : [1, 2, 3, 4, 5]} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": [1, 2, 3, 4, 5] }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, json)
    }

    func testIfInvalidBasicArrayCheckReturnsExpectedResult() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : [1, 2, 3, 4, 5]} ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/foo\", \"value\": [1, 2, 3, 4, 5, 6, 7, 42] }") else {
            XCTFail("json parse error")
            return
        }
        guard let _: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
    }
}
