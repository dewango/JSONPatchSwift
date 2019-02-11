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
        let json = try! JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/baz\", \"value\": \"qux\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: "{ \"foo\" : \"bar\", \"baz\" : \"qux\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    // http://tools.ietf.org/html/rfc6902#appendix-A.2
    func testIfPathToArrayCreatesNewArrayElement() {
        let json = try! JSON(data: " { \"foo\" : [ \"bar\", \"baz\"] } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1\", \"value\": \"qux\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: "{ \"foo\": [ \"bar\", \"qux\", \"baz\" ] }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToArrayInsertsValueAtPositionAndShiftsRemainingMembersRight() {
        let json = try! JSON(data: " [ \"foo\", 42, \"bar\" ] ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/2\", \"value\": \"42\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " [ \"foo\", 42, \"42\", \"bar\" ] ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToNonExistingMemberCreatesNewMember2() {
        let json = try! JSON(data: " { \"foo\" : \" { \"foo2\" : \"bar\" } \" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/bar\", \"value\": \"foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"foo\" : \" { \"foo2\" : \"bar\", \"bar\" : \"foo\" } \" } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToNonExistingMemberCreatesNewMember3() {
        let json = try! JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\" } \" } ] \" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1/blaa/blubby\", \"value\": \"foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\", \"blubby\" : \"foo\" } \" } ] \" } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt1() {
        let json = try! JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo\", \"value\": \"foobar\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: "{ \"foo\" : \"foobar\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathToExistingMemberReplacesIt2() {
        let json = try! JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"bloobb\" } \" } ] \" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/1/blaa/ blubb \", \"value\": \"foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"foo\" : \" [ { \"foo\" : \"bar\" }, { \"blaa\" : \" { \" blubb \" : \"foo\" } \" } ] \" } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testIfPathToRootReplacesWholeDocument() {
        let json = try! JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bar\" : \"foo\" } }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: "{ \"bar\" : \"foo\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testAddToArrayWithIndexOutOfBoundsProducesError() {
        do {
            let json = try! JSON(data: " { \"a\": [ 23, 42 ] } ".data(using: String.Encoding.utf8)!)
            let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/42\", \"value\": \"bar\" }")
            _ = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail("Unreachable code. Should have raised an error, because the array index is out of bounds.")
        } catch let message {
            // Expected behaviour.
            XCTAssertNotNil(message)
        }
    }
    
    func testAddToArrayWithIndexEqualsCount() {
        let json = try! JSON(data: " { \"a\": [ 23, 42 ] } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/2\", \"value\": \"bar\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"a\": [ 23, 42, \"bar\" ] } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfMinusAtEndOfPathAppendsToArray() {
        let json = try! JSON(data: " { \"foo\" : [ bar1, bar2, bar3 ] } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/foo/-\", \"value\": \"bar4\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"foo\" : [ bar1, bar2, bar3, bar4 ] } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfPathElementIsValid() {
        let json = try! JSON(data: " { \"a\": { \"foo\": 1 } } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b\", \"value\": \"bar\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = try! JSON(data: " { \"a\": { \"foo\": 1, \"b\" : \"bar\" } } ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfInvalidPathElementRaisesError() {
        do {
            let json = try! JSON(data: " { \"a\": { \"foo\": 1 } } ".data(using: String.Encoding.utf8)!)
            let jsonPatch = try JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/c/b\", \"value\": \"bar\" }")
            _ = try JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
            XCTFail("Unreachable code. Should have raised an error, because 'a' must exist to access 'b'.")
        } catch let message {
            XCTAssertNotNil(message)
        }
    }
    
}
