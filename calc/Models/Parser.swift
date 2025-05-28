//
//  Parser.swift
//  calc
//
//  Created by nyaago.
//

import Foundation

enum ParseError: Error {
    case symbolNotFound(symbolName: String)
    case logical(message: String)
    
    var errorDescription: String? {
        get {
            switch self {
            case .symbolNotFound(symbolName: let symbolName):
                return "symbol not found :\(symbolName) not found"
            case .logical(message: let message):
                return message
                
            }
        }
    }
}

extension Node {
    var desctiontionWhenNodeStart: String {
        get {
            if lhs != nil && parent != nil {
                return "(\(description)"
            }
            return "\(description) "
        }
    }
    
    var desctiontionWhenNodeEnd: String {
        get {
            if lhs != nil && parent != nil {
                return ")"
            }
            return ""
        }
    }
}

class Parser {
    
    private let lexer: Lexer
    private let source: String?
    private var tokens: [any Token]? = nil      // 未パースであれば null. パース開始以降0個以上の要素
    private var _symbolTable: SymbolTable
    private var _rootNode: RootNode? = nil
    private var _sentenceNde: SentenceNode? = nil
    private var bracketStack: Stack<Node> = Stack<Node>()
       
    var rootNode: RootNode? {
        get {
            return _rootNode
        }
    }

    var currentSentenceNode: SentenceNode? {
        get {
            return _sentenceNde
        }
        set {
            _sentenceNde = newValue
        }
    }
    
    var symbolTable: SymbolTable {
        get {
            return _symbolTable
        }
    }
    
    init(source: String) {
        self.source = source
        self.lexer = Lexer(source: source)
        self._symbolTable = SymbolTable()
    }
    
    init(lexer: Lexer) {
        self.source = nil
        self.lexer = lexer
        self._symbolTable = SymbolTable()
    }
    
   
    public func nodesDescription() -> String {
        guard let rootNode = self.rootNode else {
            return ""
        }
        let desc = rootNode.sentences.reduce("") { result, sentenceNode in
            if sentenceNode.lhs == nil && sentenceNode.rhs == nil { // 空行
                return result
            }
            let traverser = Traverser(rootNode: sentenceNode)
            let descriptions: [String] = traverser.map(
            closer: {node in
                return node.desctiontionWhenNodeStart
            },
            closerWhenReturned: {node in
                return node.desctiontionWhenNodeEnd
            })
            let descString = descriptions.joined(separator: "")
            if result.count == 0 {
                return descString
            }
            return "\(result) \n \(descString)"
        }
        return desc
    }
    
    private func nodeDescription(node: Node) -> String {
        return ""
    }
    
    /**
     - throws: LexerError
     */
    private func lexicalAnalize() throws -> [any Token]? {
        return try lexer.analize()
    }
    
    /**
     - 構文解析実行
     - retuen rootNode
     - throws: ParseError
     */
    func parse() throws -> RootNode {
        if tokens == nil {
            try tokens = lexicalAnalize()
        }
        self._rootNode = RootNode(token: nil)
        try parseWithTokens()
        try _symbolTable = semanticAnalize()
        return self.rootNode!
    }
    
    private func parseWithTokens() throws {
        guard let curTokens = tokens else {
            throw ParseError.logical(message: "tokens is null")
        }
        self.currentSentenceNode = SentenceNode(token: nil)
        rootNode!.appendSentence(sentenceNode: currentSentenceNode!)
        curTokens.forEach{
            let token = $0
            if token.tokenKind == .expressionSeparator {
                // new sentence
                currentSentenceNode = SentenceNode(token: token)
                rootNode!.appendSentence(sentenceNode: currentSentenceNode!)
                bracketStack = Stack<Node>()
            }
            else {
                parseWithToken(token: $0)
            }
        }
    }
    
    private func parseWithToken(token: any Token) {
        let node = NodeFactory.createNode(token: token)
        insertNode(newNode: node)
    }
    
    private func semanticAnalize() throws -> SymbolTable {
        guard let rootNode = self.rootNode else {
            return SymbolTable()
        }
        var symbolTable = SymbolTable()
        rootNode.sentences.forEach {
            let sentenceNode = $0
            let traverser = Traverser(rootNode: sentenceNode)
            
            // とりあえず、こちらでは正常動作していないので 下の forEachWithCloser で実装
            /*
            var symbolTable = traverser.reduce(initialResult: SymbolTable(), closer:{ node, result in
                let symbolTalbe = insertOrUpdateSymbol(node: node, symbolTable: result)
                return symbolTalbe
            } )
             */
            
            traverser.forEachWithCloser(result: &symbolTable, closer: { node, result in
                adoptSymbolValues(node: node, symbolTable: result)
                
                return
            } )
            traverser.forEachWithCloser(result: &symbolTable, closer: { node, result in
                insertOrUpdateSymbol(node: node, symbolTable: result)
                

                return
            } )
        }

        if symbolTable.invalidSymbols().count > 0 {
            //throw ParseError.symbolNotFound(symbolName: symbolTable.invalidSymbols()[0])
        }
        return symbolTable
    }
    
    // Symbol　の Node であれば Symbol Table への追加を行う。
    // また、子要素に式があれば値を設定
    @discardableResult
    private func insertOrUpdateSymbol(node: Node, symbolTable: SymbolTable) -> SymbolTable {
        if !node.isSymbol {
            return symbolTable
        }
        guard let token = node.token else {
            return symbolTable
        }
        if !symbolTable.contains(symbol: token.string) {
            symbolTable.appendSymbol(symbol: token.string)
        }
        if node.isLeftExpression {
            if let parent = node.parent  {
                node.value = parent.value
            }
            if node.value.isValid {
                symbolTable.assignSymbolValue(symbol: token.string, value:node.value)
            }
            else {
                symbolTable.assignSymbolValue(symbol: token.string, value:NumericWrapper(value: Double.nan))
            }
        }
        if node.value.isValid {
            if !symbolTable.containsValue(symbol: token.string) {
                symbolTable.assignSymbolValue(symbol: token.string, value:node.value)
            }
        }
        return symbolTable
    }
    
    // Symbol ノードにシンボルテーブルの値を適用する
    @discardableResult
    private func adoptSymbolValues(node: Node, symbolTable: SymbolTable) -> SymbolTable {
        if !node.isSymbol {
            return symbolTable
        }
        guard let token = node.token else {
            return symbolTable
        }
        if let symbolElement = symbolTable[token.string] {
            let symbolValue = symbolElement.value
            node.value = symbolValue
        }
        return symbolTable
    }
    
    // return 挿入されたNode
    @discardableResult
    private func insertNode(newNode: Node) -> Node? {
        var intertedNode: Node?
        if newNode.rightBrace {
            _ = bracketStack.pop()
        }
        else {
            let currentRootNode: Node
            if bracketStack.isEmpty {
                currentRootNode = currentSentenceNode!
            }
            else {
                currentRootNode = bracketStack.peek()!
            }
            intertedNode = insertNodeAt(newNode: newNode, currentNode: currentRootNode, parentNode: nil)
        }
        if newNode.leftBrace {
            bracketStack.push(element: newNode)
        }

        return intertedNode
    }

    // return 挿入されたNode
    @discardableResult
    private func insertNodeAt(newNode: Node, currentNode: Node?, parentNode: Node?) -> Node? {
        if newNode.rightBrace {
            return currentNode
        }
        if newNode.highPriorityWith(other: currentNode!) {
            if currentNode!.lhs == nil {
                currentNode!.lhs = newNode
                newNode.parent = currentNode
                return newNode
            }
            else if currentNode!.rhs == nil  {
                if currentNode!.canHasRhs {
                    currentNode!.rhs = newNode
                    newNode.parent = currentNode
                    return newNode
                }
                else {  // current が root node など 右の分岐を持たない
                    return insertNodeAt(newNode: newNode, currentNode: currentNode!.lhs, parentNode: currentNode)
                }
            }
            else { // currentNode!.lhs != nil && currentNode!.rhs != nil
                 return insertNodeAt(newNode: newNode, currentNode: currentNode!.rhs, parentNode: currentNode)
            }
        }
        //
        else  { // newNode.priority <= currentNode!.priority
            newNode.lhs = currentNode
            newNode.parent = currentNode!.parent
            if let parent = currentNode!.parent {
                if parent.lhs == currentNode  {
                    parent.lhs = newNode
                }
                else if parent.rhs == currentNode {
                    parent.rhs = newNode
                }
            }
            currentNode!.parent = newNode
            return newNode
        }
    }
}
