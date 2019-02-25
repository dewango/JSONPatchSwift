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

// http://tools.ietf.org/html/rfc6902#section-4.1
// 4.  Operations
// 4.1.  add

class JPSAddOperationTests: XCTestCase {

    // http://tools.ietf.org/html/rfc6902#appendix-A.1
    func testIfPathToNonExistingMemberCreatesNewMember1() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/baz\", \"value\": \"qux\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"foo\": \"bar\", \"baz\": \"qux\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    // http://tools.ietf.org/html/rfc6902#appendix-A.2
    func testIfPathToArrayCreatesNewArrayElement() {
        guard let json: JSON = try? JSON(data: " { \"foo\": [ \"bar\", \"baz\"] } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1\", \"value\": \"qux\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"foo\": [ \"bar\", \"qux\", \"baz\" ] }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToArrayInsertsValueAtPositionAndShiftsRemainingMembersRight() {
        guard let json: JSON = try? JSON(data: " [ \"foo\", 42, \"bar\" ] ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/2\", \"value\": \"42\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " [ \"foo\", 42, \"42\", \"bar\" ] ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToNonExistingMemberCreatesNewMember2() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \" { \"foo2\": \"bar\" } \" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/bar\", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: (" { \"foo\": \" { \"foo2\": "
            + "\"bar\", \"bar\": \"foo\" } \" } ").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToNonExistingMemberCreatesNewMember3() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \" [ { \"foo\": \"bar\" }, { \"blaa\": \" { \" blubb \": \"bloobb\" } \" } ] \" } ".data(
            using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1/blaa/blubby\", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: (" { \"foo\": \" [ { \"foo\": \"bar\" }, { \"blaa\": "
            + "\" { \" blubb \": \"bloobb\", \"blubby\": \"foo\" } \" } ] \" } ").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToExistingMemberReplacesIt1() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo\", \"value\": \"foobar\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"foo\": \"foobar\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToExistingMemberReplacesIt2() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \" [ { \"foo\": \"bar\" }, { \"blaa\": \" { \" blubb \": \"bloobb\" } \" } ] \" } ".data(
            using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1/blaa/ blubb \", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: (" { \"foo\": \" [ { \"foo\": \"bar\" }, "
            + "{ \"blaa\": \" { \" blubb \": \"foo\" } \" } ] \" } ").data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToRootReplacesWholeDocument() {
        guard let json: JSON = try? JSON(data: " { \"foo\": \"bar\" } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bar\": \"foo\" } }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: "{ \"bar\": \"foo\" }".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testAddToArrayWithIndexOutOfBoundsProducesError() {
        do {
            guard let json: JSON = try? JSON(data: " { \"a\": [ 23, 42 ] } ".data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
            }
            guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/42\", \"value\": \"bar\" }") else {
                XCTFail("json parse error")
                return
            }
            _ = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail("Unreachable code. Should have raised an error, because the array index is out of bounds.")
            // swiftlint:disable:next explicit_type_interface
        } catch let message {
            // Expected behaviour.
            XCTAssertNotNil(message)
        }
    }

    func testAddToArrayWithIndexEqualsCount() {
        guard let json: JSON = try? JSON(data: " { \"a\": [ 23, 42 ] } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/2\", \"value\": \"bar\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " { \"a\": [ 23, 42, \"bar\" ] } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfMinusAtEndOfPathAppendsToArray() {
        guard let json: JSON = try? JSON(data: " { \"foo\": [ bar1, bar2, bar3 ] } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/-\", \"value\": \"bar4\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " { \"foo\": [ bar1, bar2, bar3, bar4 ] } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathElementIsValid() {
        guard let json: JSON = try? JSON(data: " { \"a\": { \"foo\": 1 } } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b\", \"value\": \"bar\" }") else {
            XCTFail("json parse error")
            return
        }
        guard let resultingJson: JSON = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json) else {
            XCTFail("json parse error")
            return
        }
        guard let expectedJson: JSON = try? JSON(data: " { \"a\": { \"foo\": 1, \"b\": \"bar\" } } ".data(using: String.Encoding.utf8)!) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfInvalidPathElementRaisesError() {
        do {
            guard let json: JSON = try? JSON(data: " { \"a\": { \"foo\": 1 } } ".data(using: String.Encoding.utf8)!) else {
                XCTFail("json parse error")
                return
            }
            guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/c/b\", \"value\": \"bar\" }") else {
                XCTFail("json parse error")
                return
            }
            _ = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail("Unreachable code. Should have raised an error, because 'a' must exist to access 'b'.")
            // swiftlint:disable:next explicit_type_interface
        } catch let message {
            XCTAssertNotNil(message)
        }
    }

}
