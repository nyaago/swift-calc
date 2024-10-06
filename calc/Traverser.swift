//
//  traverser.swift
//  calc
//
//  Created by nyaago on 2021/10/27.
//

import Foundation

class Traverser: CustomStringConvertible {
    
    private let rootNode: RootNode
    
    init(rootNode: RootNode) {
        self.rootNode = rootNode
    }
    
    func map<T>(closer:  (Node) -> T) -> [T] {
        mapNext(node: self.rootNode, closer: closer)
    }
    
    func mapNext<T>(node: Node?, closer:  (Node) -> T) -> [T] {
        var array: [T] = []
        if let currentNode = node {
            array.append(closer(currentNode))
            array = array + mapNext(node: currentNode.lhs, closer: closer)
            array = array + mapNext(node: currentNode.rhs, closer: closer)
        }
        return array
    }
    
    var description: String {
        get {
            map(closer: { $0.description }).joined(separator: "|")
        }
    }
}
