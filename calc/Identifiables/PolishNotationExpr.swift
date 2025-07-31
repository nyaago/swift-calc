//
//  PolishNotation.swift
//  calc
//
//  Created by nyaago on 2025/04/09.
//

import SwiftUI

struct PolishNotationExpr: Identifiable, Hashable {
    
    let _node: SentenceNode
        
    let id = UUID()

    init(sentenceNode: SentenceNode) {
        self._node = sentenceNode
    }

    var node: SentenceNode {
        get {
            return _node
        }
    }
    
    var value: NumericWrapper? {
        get {
            return node.value
        }
    }
    
    var strtingValue: String {
        get {
            return value?.stringValue ?? ""
        }
    }
    
    var expr: String {
        get {
            return node.polishNotationString
        }
    }
    
    var stringValue: String {
        get {
            return node.value.stringValue
        }
    }
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
