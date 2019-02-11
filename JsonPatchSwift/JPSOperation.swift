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

func == (lhs: JPSOperation, rhs: JPSOperation) -> Bool {
    return lhs.type == rhs.type
}

/// RFC 6902 compliant JavaScript Object Notation (JSON) Patch operation implementation, see https://tools.ietf.org/html/rfc6902#page-4.
public struct JPSOperation {
    
    /// Operation types as stated in https://tools.ietf.org/html/rfc6902#page-4.
    public enum JPSOperationType: String {
        /** Add: The `add` operation. */
        case add
        /** Remove: The `remove` operation. */
        case remove
        /** Replace: The `replace` operation. */
        case replace
        /** Move: The `move` operation. */
        case move
        /** Copy: The `copy` operation. */
        case copy
        /** Test: The `test` operation. */
        case test
    }
    
    let type: JPSOperationType
    let pointer: JPSJsonPointer
    let value: JSON
    let from: JPSJsonPointer?
}
