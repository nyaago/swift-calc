//
//  IdentigableSentenceNode.swift
//  calc
//
//  Created by nyaago on 2025/07/15.
//

import SwiftUI

struct IdentifiableSentenceNode: Identifiable, Hashable {
    let id = UUID()
    private var _node: SentenceNode
    
    init(sentenceNode: SentenceNode) {
        self._node = sentenceNode
    }

    var node: SentenceNode {
        get {
            self._node
        }
    }

    var value: NumericWrapper {
        get {
            return node.value
        }
    }
    
    var strtingValue: String {
        get {
            return value.stringValue
        }
    }
    
    var sentenceText: String {
        get {
            self.node.sentenceText
        }
    }
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
