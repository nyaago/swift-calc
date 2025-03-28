//
//  ExprVariable.swift
//  calc
//
//  Created by nyaago on 2025/01/21.
//

import SwiftUI

struct ExprVariable: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: NumericWrapper?
    
    var listItemText: String {
        get {
            let valueString = value?.description ?? ""
            return "\(name) = \(valueString)"
        }
    }
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
