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
            return SymbolNode(token: token)
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
    
    fileprivate var newPrecedence: Int?
    
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
    
    // 結合度の高さ
    class var precedence: Int {
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

    // 結合度の高さ
    var precedence: Int {
        get {
            return type(of: self).precedence
        }
    }
    
    
    // 右の子ノードを持つことができるかどうか。
    // 文や = は 右の子ノードを持つことができない
    var canHasRhs: Bool {
        get {
            return true
        }
    }
    
    // 代入演算子 ( = )か?
    var isAssignmentOperator:Bool {
        get {
            return false
        }
    }
    
    // brace で囲まれた式の起点であるかを判定する
    var leftBrace: Bool {
        get {
            return false
        }
    }

    // brace で囲まれた式の終点であるかを判定する
    var rightBrace: Bool {
        get {
            return false
        }
    }
    
    // 演算子か?
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

    // 代入の左側 (代入される側)であるか?
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
    
    func highPrecedenceWith(other: Node) -> Bool {
        return self.precedence > other.precedence
    }
}

class RootNode: Node {
    
    private var _sentences: Array<SentenceNode> = Array()
    
    
    override class var precedence: Int {
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
        set {
            self._sentences = newValue
        }
    }
    
    func appendSentence(sentenceNode: SentenceNode) {
        _sentences.append(sentenceNode)
    }
    
    public func polishNotationDescription() -> String {
        let traverser = Traverser(rootNode: self)
        let descriptions: [String] = traverser.map(
        closer: {node in
            return node.desctiontionWhenNodeStart
        },
        closerWhenReturned: {node in
            return node.desctiontionWhenNodeEnd
        })
        let descString = descriptions.joined(separator: "")
        return descString
    }
}

class IntegerNode: Node {
    override class var precedence: Int {
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
    
    override func highPrecedenceWith(other: Node) -> Bool {
        return self.precedence > other.precedence
    }
}

class NumericNode: Node {
    override class var precedence: Int {
        get {
            return IntegerNode.precedence
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
    override class var precedence: Int {
        get {
            return IntegerNode.precedence - 100
        }
    }
    
    override var precedence: Int {
        get {
            switch self.string {
            case "+", "-":
                return type(of: self).precedence - 10
            case "*", "/":
                return type(of: self).precedence - 5
            case "=":
                return SentenceNode.precedence + 5
            default:
                return type(of: self).precedence
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
}

class BraceNode: Node {
    override class var precedence: Int {
        get {
            return 10000
        }
    }

    // 定義したけど,参照されないはず
    // isLeftBrace と isRightBrace で判定しているため
    override var precedence: Int {
        get {
            if self.lhs == nil && self.rhs == nil && self.parent == nil {
                // 新規に挿入されるケース。優先度が低い = 他のノードの親になる
                return type(of: self).precedence
            }
            else {
                // Brace 内の要素を挿入する場合、挿入される要素より結合度が低い。
                return SentenceNode.precedence + 5
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
    override class var precedence: Int {
        get {
            return BraceNode.precedence
        }
    }
    override var rightBrace: Bool {
        get {
            return true
        }
    }
}

class SymbolNode: Node {
    override class var precedence: Int {
        get {
            return IntegerNode.precedence
        }
    }
    
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
    
    override func highPrecedenceWith(other: Node) -> Bool {
        return self.precedence > other.precedence
    }

}

class SentenceNode: Node {
    
    override class var precedence: Int {
        get {
            return RootNode.precedence + 5
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
    override var precedence: Int {
        get {
            if parent != nil {
                return 1000
            }
            else {
                return Self.precedence
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
    
    var polishNotationString: String {
        let traverser = Traverser(rootNode: self)
        let strings: [String] = traverser.map(
        closer: {node in
            return node.desctiontionWhenNodeStart
        },
        closerWhenReturned: {node in
            return node.desctiontionWhenNodeEnd
        })
        let string = strings.joined(separator: "")
        return string
    }
}
