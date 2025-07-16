//
//  IdentigableSentenceNode.swift
//  calc
//
//  Created by nyaago on 2025/07/15.
//

import SwiftUI

struct IdentigableSentenceNode: Identifiable, Hashable {
    let id = UUID()
    let _node: SentenceNode
    
    init(sentenceNode: SentenceNode) {
        self._node = sentenceNode
    }

    var node: SentenceNode {
        get {
            self._node
        }
    }
    
    
    func hash(into: inout Hasher) {
        return id.hash(into: &into)
    }
}
