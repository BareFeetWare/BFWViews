//
//  JSON+Node.swift
//  BFWViewsFetch
//
//  Created by Tom Brodhurst-Hill on 14/4/2026.
//  Copyright © 2026 BareFeetWare. All rights reserved.
//

import BFWFetch
import BFWViews

// Retroactive conformance: neither `JSON` (BFWFetch) nor `Plan.Node` (BFWViews)
// is owned by this module. `@retroactive` silences the Swift warning and
// explicitly acknowledges the risk: if BFWFetch ever declares its own
// `JSON: Plan.Node` conformance, this extension will need to be removed.
// We accept that trade-off to keep BFWFetch and BFWViews independent of
// each other — this bridge framework exists precisely to avoid coupling them.
extension JSON: @retroactive Plan.Node {

    public var asDictionary: [String: JSON]? {
        if case .dictionary(let dictionary) = self { dictionary } else { nil }
    }

    public var asArray: [JSON]? {
        if case .array(let array) = self { array } else { nil }
    }

    // singleValueString is already defined on JSON.
}
