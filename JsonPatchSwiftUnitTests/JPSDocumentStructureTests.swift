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

// http://tools.ietf.org/html/rfc6902#section-3
// 3. Document Structure (and the general Part of Chapter 4)

class JPSDocumentStructureTests: XCTestCase {

    func testJsonPatchContainsArrayOfOperations() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
    }

    func testJsonPatchReadsAllOperations() {
        guard let jsonPatch = try? JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, "
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"test\", \"path\": "
            + "\"/a/b/c\", \"value\": \"foo\" }]") else {
                XCTFail("json parse error")
                return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 3)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
    }

    func testJsonPatchOperationsHaveSameOrderAsInJsonRepresentation() {
        guard let jsonPatch = try? JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, "
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }, { \"op\": \"remove\", \"path\": "
            + "\"/a/b/c\", \"value\": \"foo\" }]") else {
                XCTFail("json parse error")
                return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 3)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1: JPSOperation = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.add)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2: JPSOperation = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.remove)
    }

    // This is about the JSON format in general.
    func testJsonPatchRejectsInvalidJsonFormat() {
        do {
            _ = try JPSJsonPatch("!#€%&/()*^*_:;;:;_poawolwasnndaw")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidJsonFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testJsonPatchWithDictionaryAsRootElementForOperationTest() {
        guard let jsonPatch = try? JPSJsonPatch("{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.test)
    }

    func testJsonPatchWithDictionaryAsRootElementForOperationAdd() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.add)
    }

    func testJsonPatchWithDictionaryAsRootElementForOperationCopy() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/a/b/c\", \"from\": \"/foo\" }") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.copy)
    }

    func testJsonPatchWithDictionaryAsRootElementForOperationRemove() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"remove\", \"path\": \"/a/b/c\" }") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.remove)
    }

    func testJsonPatchWithDictionaryAsRootElementForOperationReplace() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": \"foo\" }") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0 = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.replace)
    }

    func testJsonPatchRejectsMissingOperation() {
        do {
            _ = try JPSJsonPatch("{ \"path\": \"/a/b/c\", \"value\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.OpElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testJsonPatchRejectsMissingPath() {
        do {
            _ = try JPSJsonPatch("{ \"op\": \"add\", \"value\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.PathElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testJsonPatchSavesValue() {
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]") else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        XCTAssertEqual(jsonPatch.operations[0].value.string, "foo")
    }

    func testJsonPatchRejectsMissingValue() {
        do {
            _ = try JPSJsonPatch("{ \"op\": \"add\", \"path\": \"foo\" }")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Could not find 'value' element.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testJsonPatchRejectsEmptyArray() {
        do {
            _ = try JPSJsonPatch("[]")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Patch array does not contain elements.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    // Examples from the RFC itself.
    func testIfExamplesFromRFCAreRecognizedAsValidJsonPatches() {
        let patch: String = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/a/b/c\" },"
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": [ \"foo\", \"bar\" ] },"
            + "{ \"op\": \"replace\", \"path\": \"/a/b/c\", \"value\": 42 },"
            + "{ \"op\": \"move\", \"from\": \"/a/b/c\", \"path\": \"/a/b/d\" },"
            + "{ \"op\": \"copy\", \"from\": \"/a/b/d\", \"path\": \"/a/b/e\" }"
            + "]"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 6)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.test)
        XCTAssertTrue((jsonPatch.operations[1] as Any) is JPSOperation)
        let operation1: JPSOperation = jsonPatch.operations[1]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.remove)
        XCTAssertTrue((jsonPatch.operations[2] as Any) is JPSOperation)
        let operation2: JPSOperation = jsonPatch.operations[2]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.add)
        XCTAssertTrue((jsonPatch.operations[3] as Any) is JPSOperation)
        let operation3: JPSOperation = jsonPatch.operations[3]
        XCTAssertEqual(operation3.type, JPSOperation.JPSOperationType.replace)
        XCTAssertTrue((jsonPatch.operations[4] as Any) is JPSOperation)
        let operation4: JPSOperation = jsonPatch.operations[4]
        XCTAssertEqual(operation4.type, JPSOperation.JPSOperationType.move)
        XCTAssertTrue((jsonPatch.operations[5] as Any) is JPSOperation)
        let operation5: JPSOperation = jsonPatch.operations[5]
        XCTAssertEqual(operation5.type, JPSOperation.JPSOperationType.copy)
    }

    func testInvalidJsonGetsRejected() {
        do {
            _ = try JPSJsonPatch("{op:foo}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch {
            // Expected behaviour.
        }
    }

    func testInvalidOperationsAreRejected() {
        do {
            _ = try JPSJsonPatch("{\"op\" : \"foo\", \"path\" : \"/a/b\"}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, "Operation is invalid.")
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    // JSON Pointer: RFC6901
    // Multiple tests necessary here
    func testIfPathContainsValidJsonPointer() {
        do {
            _ = try JPSJsonPatch("{\"op\" : \"add\", \"path\" : \"foo\" , \"value\" : \"foo\"}")
            XCTFail("Unreachable code. Should have raised an error.")
        } catch JPSJsonPointerError.valueDoesNotContainDelimiter {
            // Expected behaviour.
        } catch {
            XCTFail("Unexpected error.")
        }
    }

    func testIfAdditionalElementsAreIgnored() {
        let patch: String = "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.test)
    }

    func testIfElementsNotNecessaryForOperationAreIgnored() {
        let patch: String = "{ \"op\": \"remove\", \"path\": \"/a/b/c\", \"value\": \"foo\", \"additionalParamter\": \"foo\" }"
        guard let jsonPatch: JPSJsonPatch = try? JPSJsonPatch(patch) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch)
        XCTAssertNotNil(jsonPatch.operations)
        XCTAssertEqual(jsonPatch.operations.count, 1)
        XCTAssertTrue((jsonPatch.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.remove)
    }

    func testIfReorderedMembersOfOneOperationLeadToSameResult() {
        // Examples from RFC:
        let patch0: String = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        guard let jsonPatch0: JPSJsonPatch = try? JPSJsonPatch(patch0) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch0)
        XCTAssertNotNil(jsonPatch0.operations)
        XCTAssertEqual(jsonPatch0.operations.count, 1)
        XCTAssertTrue((jsonPatch0.operations[0] as Any) is JPSOperation)
        let operation0: JPSOperation = jsonPatch0.operations[0]
        XCTAssertEqual(operation0.type, JPSOperation.JPSOperationType.add)

        let patch1: String = "{ \"path\": \"/a/b/c\", \"op\": \"add\", \"value\": \"foo\" }"
        guard let jsonPatch1: JPSJsonPatch = try? JPSJsonPatch(patch1) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch1)
        XCTAssertNotNil(jsonPatch1.operations)
        XCTAssertEqual(jsonPatch1.operations.count, 1)
        XCTAssertTrue((jsonPatch1.operations[0] as Any) is JPSOperation)
        let operation1: JPSOperation = jsonPatch1.operations[0]
        XCTAssertEqual(operation1.type, JPSOperation.JPSOperationType.add)

        let patch2: String = "{ \"value\": \"foo\", \"path\": \"/a/b/c\", \"op\": \"add\" }"
        guard let jsonPatch2: JPSJsonPatch = try? JPSJsonPatch(patch2) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertNotNil(jsonPatch2)
        XCTAssertNotNil(jsonPatch2.operations)
        XCTAssertEqual(jsonPatch2.operations.count, 1)
        XCTAssertTrue((jsonPatch2.operations[0] as Any) is JPSOperation)
        let operation2: JPSOperation = jsonPatch2.operations[0]
        XCTAssertEqual(operation2.type, JPSOperation.JPSOperationType.add)

        XCTAssertTrue(jsonPatch0 == jsonPatch1)
        XCTAssertTrue(jsonPatch0 == jsonPatch2)
        XCTAssertTrue(jsonPatch1 == jsonPatch2)
        XCTAssertTrue(operation0 == operation1)
        XCTAssertTrue(operation0 == operation2)
        XCTAssertTrue(operation1 == operation2)
    }

    func testEqualityOperatorWithDifferentAmountsOfOperations() {
        let patch0: String = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        let patch1: String = "["
            + "{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" },"
            + "]"
        guard let jsonPatch0: JPSJsonPatch = try? JPSJsonPatch(patch0) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch1: JPSJsonPatch = try? JPSJsonPatch(patch1) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }

    func testEqualityOperatorWithDifferentOperations() {
        let patch0: String = "{ \"op\": \"add\", \"path\": \"/a/b/c\", \"value\": \"foo\" }"
        let patch1: String = "{ \"op\": \"remove\", \"path\": \"/a/b/c\" }"
        guard let jsonPatch0: JPSJsonPatch = try? JPSJsonPatch(patch0) else {
            XCTFail("json parse error")
            return
        }
        guard let jsonPatch1: JPSJsonPatch = try? JPSJsonPatch(patch1) else {
            XCTFail("json parse error")
            return
        }
        XCTAssertFalse(jsonPatch0 == jsonPatch1)
    }

}
