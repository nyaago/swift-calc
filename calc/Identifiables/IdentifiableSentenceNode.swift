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
    private var _text: String?
    
    init(sentenceNode: SentenceNode) {
        self._node = sentenceNode
        self._text = sentenceNode.sentenceText
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
        set {
            _text = newValue
        }
    }
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
