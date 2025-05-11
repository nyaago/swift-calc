//
//  PolishNotation.swift
//  calc
//
//  Created by nyaago on 2025/04/09.
//

import SwiftUI

struct PolishNotationExpr: Identifiable, Hashable {
    let id = UUID()
    let expr: String
    let value: NumericWrapper?

    var strtingValue: String {
        get {
            return value?.stringValue ?? ""
        }
    }
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
