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
        case .expressionSeparator:
            return SentenceNode(token: token)
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
    }
    var canHasRhs: Bool {
        get {
            return true
        }
    }
    
    var isAssignmentOperator:Bool {
        get {
            return false
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
    
    var isOperatable: Bool {
        get {
            return false
        }
    }
    
    var value: NumericWrapper {
        get {
            return 0
        }
        set {
            
        }
    }
    
    var isSymbol: Bool {
        get {
            return false
        }
    }

    var isLeftExpression: Bool {
        get {
            return false
        }
    }
    
    var isFirstOfExpression: Bool {
        get {
            if parent is RootNode {
                return true
            }
            // 改行後
            return false
        }
    }
    
    func highPriorityWith(other: Node) -> Bool {
        return self.priority > other.priority
    }
}

class RootNode: Node {
    
    private var _sentences: Array<SentenceNode> = Array()
    
    
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
            if sentences.count == 0 {
                return NumericWrapper(value: Double.nan)
            }
            let reversed = sentences.reversed().drop(while: {e in
                e.value.isNotValid
            })
            if reversed.count == 0 {
                return NumericWrapper(value: Double.nan)
            }
            return reversed.first!.value
        }
        set {
            
        }
    }
    
    var sentences: Array<SentenceNode> {
        get {
            return _sentences
        }
    }
    
    func appendSentence(sentenceNode: SentenceNode) {
        _sentences.append(sentenceNode)
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
        set {
            
        }
    }
    
    override func highPriorityWith(other: Node) -> Bool {
        return self.priority > other.priority
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
        set {
            
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
            case "=":
                return SentenceNode.priority + 5
            default:
                return type(of: self).priority
            }
        }
    }
    
    override var canHasRhs: Bool {
        get {
            if isAssignmentOperator {
                return true
            }
            return true
        }
    }
    
    override var isAssignmentOperator: Bool {
        get {
            if self.string == "=" {
                return true
            }
            return super.isAssignmentOperator
        }
    }
    
    override var isOperatable: Bool {
        get {
            return true
        }
    }
    
    
    override var value: NumericWrapper {
        get {
            var leftVal: NumericWrapper = NumericWrapper(value: Double.nan)
            var rightVal: NumericWrapper = NumericWrapper(value: Double.nan)
            if !isAssignmentOperator {
                if let lhs = self.lhs {
                    leftVal = lhs.value
                }
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
            case "=":
                if rightVal.isValid {
                    return rightVal
                }
                return leftVal
            default:
                return 0
            }
        }
        set {
            
        }
    }
    
    /*
    override func highPriorityWith(other: Node) -> Bool {
        if self.isAssignmentOperator && other.isSymbol && other.parent is SentenceNode {
            return true
        }
        else {
            return self.priority > other.priority
        }
    }
     */
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
        set {
            
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
            return IntegerNode.priority
        }
    }
    
    /*
    override var priority: Int {
        get {
            if isLeftExpression {
                return SentenceNode.priority + 1
            }
            else {
                return Self.priority
            }
        }
        set {
            
        }
    }
     */
    
    override var isSymbol: Bool {
        get {
            return true
        }
    }
    
    override var canHasRhs: Bool {
        get {
            if isLeftExpression {
                return false
            }
            return true
        }
    }

    private var _value: NumericWrapper?
    override var value: NumericWrapper {
        get {
            if let v = _value  {
                return v
            }
            guard let parent = self.parent else {
                return NumericWrapper(value: Double.nan)
            }
            if parent.isAssignmentOperator && parent.lhs == self {
                return parent.value
            }
            return NumericWrapper(value: Double.nan)
        }
        set {
            self._value = newValue
        }
    }
    
    override var isLeftExpression:Bool {
        get {
            guard let parent = self.parent else  {
                return false
            }
            if parent.isAssignmentOperator {
                return true
            }
            return false
        }
    }
    
    
    
    override func highPriorityWith(other: Node) -> Bool {
        return self.priority > other.priority
    }

}

class SentenceNode: Node {
    
    
    override class var priority: Int {
        get {
            return RootNode.priority + 5
        }
    }
   
    
    override var value: NumericWrapper {
        get {
            // 右側(後にある)式の結果を優先して返す
            var val: NumericWrapper = NumericWrapper(value: Double.nan)
            if let lhs = self.lhs {
                val = lhs.value
            }
            if let rhs = self.rhs {
                val = rhs.value
            }
            return val
        }
        set {
            
        }
    }
    override var priority: Int {
        get {
            if parent != nil {
                return 1000
            }
            else {
                return Self.priority
            }
        }
    }
    
    override var canHasRhs: Bool {
        get {
            return false
        }
    }
    
    override var description: String {
        return ""
    }
}
