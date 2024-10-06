//
//  Node.swift
//  calc
//
//  Created by nyaago.
//

import Foundation


class NodeFactory {
    static func createNode(token: Token) -> Node {
        switch token.tokenKind {
        case TokenKind.integer:
            return IntegerNode(token: token)
        case TokenKind.numeric:
            return NumericNode(token: token)
        case TokenKind.operator:
            return OperatorNode(token: token)
        case TokenKind.leftBracket:
            return BraceNode(token: token)
        case TokenKind.rightBracket:
            return RightBraceNode(token: token)
        case .word:
            return WordNode(token: token)
        }
    }
}


class Node: CustomStringConvertible, Equatable {
    let token: Token?
    public var lhs: Node?
    public var rhs: Node?
    public var parent: Node?
    
    fileprivate var newPriority: Int?
    
    init(token: Token?) {
        self.token = token
    }
    
    static func ==(l: Node, r: Node) -> Bool{
        return ObjectIdentifier(l) == ObjectIdentifier(r)
    }

    var description: String {
        if let token = self.token {
            return token.description
        }
        else {
            return ""
        }
    }
    
   
    class var priority: Int {
        get {
            return 0
        }
    }
    
    var string: String {
        if let token = self.token {
            return token.string
        }
        else {
            return ""
        }
    }

    var priority: Int {
        get {
            if let returnPriority = newPriority {
                return returnPriority
            }
            return type(of: self).priority
        }
        set(newValue) {
            self.newPriority = newValue
        }
    }
    var canHasRhs: Bool {
        get {
            return true
        }
    }
    
    var leftBrace: Bool {
        get {
            return false
        }
    }

    var rightBrace: Bool {
        get {
            return false
        }
    }

}

class RootNode: Node {
    override class var priority: Int {
        get {
            return 0
        }
    }
    override var canHasRhs: Bool {
        get {
            return false
        }
    }
}

class IntegerNode: Node {
    override class var priority: Int {
        get {
            return 1000
        }
    }
}


class NumericNode: Node {
    override class var priority: Int {
        get {
            return IntegerNode.priority
        }
    }
}

class OperatorNode: Node {
    override class var priority: Int {
        get {
            return IntegerNode.priority - 100
        }
    }
    
    override var priority: Int {
        get {
            switch self.string {
            case "+", "-":
                return type(of: self).priority - 10
            case "*", "/":
                return type(of: self).priority - 5
            default:
                return type(of: self).priority
            }
        }
        set(newValue) {
            self.newPriority = newValue
        }
    }
}

class BraceNode: Node {
    override class var priority: Int {
        get {
            return 10000
        }
    }

    override var priority: Int {
        get {
            if self.lhs == nil && self.rhs == nil && self.parent == nil  {
                return type(of: self).priority
            }
            else {
                return RootNode.priority + 10
            }
        }
        set(newValue) {
            self.newPriority = newValue
        }
    }

    override var leftBrace: Bool {
        get {
            return true
        }
    }
    override var canHasRhs: Bool {
        get {
            return false
        }
    }
}

class RightBraceNode: Node {
    override class var priority: Int {
        get {
            return BraceNode.priority
        }
    }
    override var rightBrace: Bool {
        get {
            return true
        }
    }
}

class WordNode: Node {
    override class var priority: Int {
        get {
            return 1000
        }
    }
}
