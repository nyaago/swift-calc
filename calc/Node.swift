//
//  Node.swift
//  calc
//
//  Created by nyaago.
//

import Foundation


class NodeFactory {
    static func createNode(token: any Token) -> Node {
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
    let token: (any Token)?
    public var lhs: Node?
    public var rhs: Node?
    public var parent: Node?
    
    fileprivate var newPriority: Int?
    
    init(token: (any Token)?) {
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
    
    var value: NumericWrapper {
        get {
            return 0
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
    
    override var value: NumericWrapper {
        get {
            guard let lhs = self.lhs else {
                return 0
            }
            return lhs.value
        }
    }
}

class IntegerNode: Node {
    override class var priority: Int {
        get {
            return 1000
        }
    }
    override var value: NumericWrapper {
        get {
            guard let token = self.token else {
                return 0
            }
            let wrappedVal = Int64(token.string)
            guard let val = wrappedVal else {
                return 0
            }
            return NumericWrapper(value: val)
        }
    }
}


class NumericNode: Node {
    override class var priority: Int {
        get {
            return IntegerNode.priority
        }
    }
    
    override var value: NumericWrapper {
        get {
            guard let token = self.token else {
                return 0
            }
            let wrappedVal = Double(token.string)
            guard let val = wrappedVal else {
                return NumericWrapper(value: 0.0)
            }
            return NumericWrapper(value: val)
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
    
    
    override var value: NumericWrapper {
        get {
            var leftVal: NumericWrapper = 0
            var rightVal: NumericWrapper = 0
            if let lhs = self.lhs {
                leftVal = lhs.value
            }
            if let rhs = self.rhs {
                rightVal = rhs.value
            }
            switch self.string {
            case "+":
                return leftVal + rightVal
            case "-":
                return leftVal - rightVal
            case "*":
                return leftVal * rightVal
            case "/":
                return leftVal / rightVal
            default:
                return 0
            }
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
    
    override var value: NumericWrapper {
        get {
            guard let lhs = self.lhs else {
                return 0
            }
            return lhs.value
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
