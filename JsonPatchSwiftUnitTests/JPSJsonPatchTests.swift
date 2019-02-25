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

class JPSJsonPatchTests: XCTestCase {

    func testMultipleOperations1() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        let patch: String = "["
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "]"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"bar\" : \"foo\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testMultipleOperations2() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        let patch: String = "["
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "]"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"bar\" : \"foo\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testMultipleOperations3() {
        guard let json: JSON = try? JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        let patch: String = "["
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bla\" : \"blubb\" }  },"
            + "{ \"op\": \"replace\", \"path\": \"/bla\", \"value\": \"/bla\" },"
            + "{ \"op\": \"add\", \"path\": \"/bla\", \"value\": \"blub\" },"
            + "{ \"op\": \"copy\", \"path\": \"/blaa\", \"from\": \"/bla\" },"
            + "{ \"op\": \"move\", \"path\": \"/bla\", \"from\": \"/blaa\" },"
            + "]"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"bla\" : \"blub\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testInitWithSwiftyJSON() {
        guard let jsonPatchString: JPSJsonPatch = try? JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]") else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatchSwifty: JPSJsonPatch = try? JPSJsonPatch(JSON(data: (" [{ \"op\": \"test\", "
            + "\"path\": \"/a/b/c\", \"value\": \"foo\" }] ").data(using: String.Encoding.utf8)!)) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertTrue(jsonPatchString == jsonPatchSwifty)
    }
}
