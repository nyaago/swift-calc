//
//  traverser.swift
//  calc
//
//  Created by nyaago on 2021/10/27.
//

import Foundation

class Traverser: CustomStringConvertible {
    
    private let rootNode: Node
    
    init(rootNode: Node) {
        self.rootNode = rootNode
    }
    
    func map<T>(closer:  (Node) -> T) -> [T] {
        mapNext(node: self.rootNode, closer: closer)
    }

    func map<T>(closer:  (Node) -> T, closerWhenReturned:  (Node) -> T) -> [T] {
        mapNext(node: self.rootNode, closer: closer, closerWhenReturned: closerWhenReturned)
    }

    
    private func mapNext<T>(node: Node?, closer:  (Node) -> T) -> [T] {
        var array: [T] = []
        if let currentNode = node {
            array.append(closer(currentNode))
            array = array + mapNext(node: currentNode.lhs, closer: closer)
            array = array + mapNext(node: currentNode.rhs, closer: closer)
        }
        return array
    }

    private func mapNext<T>(node: Node?, closer:  (Node) -> T, closerWhenReturned:  (Node) -> T) -> [T]   {
        var array: [T] = []
        if let currentNode = node {
            array.append(closer(currentNode))
            array = array + mapNext(node: currentNode.lhs, closer: closer, closerWhenReturned: closerWhenReturned)
            array = array + mapNext(node: currentNode.rhs, closer: closer, closerWhenReturned: closerWhenReturned)
            array.append(closerWhenReturned(currentNode))
        }
        return array
    }

    
    
    func forEach<T>(closer:  (Node) -> T) -> Void {
        forEachNext(node: self.rootNode, closer: closer)
    }

    func forEachNext<T>(node: Node?, closer:  (Node) -> T) -> Void {
        if let currentNode = node {
            _ = closer(currentNode)
            forEachNext(node: currentNode.lhs, closer: closer)
            forEachNext(node: currentNode.rhs, closer: closer)
        }
    }

    func reduce<T>(initialResult: T, closer: (Node, T) -> T) -> T {
        reduceNext(result: initialResult, node: self.rootNode, closer: closer)
    }

    func reduceNext<T>(result: T, node: Node?, closer:  (Node, T) -> T) -> T {
        var newResult = result
        if let currentNode = node {
            if currentNode.lhs != nil {
                newResult = reduceNext(result: newResult, node: currentNode.lhs, closer: closer)
            }
            if currentNode.rhs != nil {
                newResult = reduceNext(result: newResult, node: currentNode.rhs, closer: closer)
            }
            newResult = closer(currentNode, newResult)
        }
        return result
    }
    
    func forEachWithCloser<T>(result: inout T, closer: (Node, inout T) -> Void) -> Void {
        forEachWithCloserNext(result: &result, node: self.rootNode, closer: closer)
    }

        
    func forEachWithCloserNext<T>( result: inout T, node: Node?, closer:  (Node, inout T) -> Void) -> Void {
        if let currentNode = node {
            if currentNode.lhs != nil {
                forEachWithCloserNext(result: &result, node: currentNode.lhs, closer: closer)
            }
            if currentNode.rhs != nil {
                forEachWithCloserNext(result: &result, node: currentNode.rhs, closer: closer)
            }
            closer(currentNode, &result)
        }
        return
    }

    func forEachLeftWithCloser<T>(result: inout T, closer: (Node, inout T) -> Void) -> Void {
        forEachLeftWithCloserNext(result: &result, node: self.rootNode, closer: closer)
    }

        
    func forEachLeftWithCloserNext<T>( result: inout T, node: Node?, closer:  (Node, inout T) -> Void) -> Void {
        if let currentNode = node {
            if currentNode.lhs != nil {
                forEachWithCloserNext(result: &result, node: currentNode.lhs, closer: closer)
            }
            closer(currentNode, &result)
        }
        return
    }

    
    var description: String {
        get {
            return map(closer: { return $0.description }).joined(separator: "|")
        }
    }
}
