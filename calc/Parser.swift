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

class Parser {
    
    private let lexer: Lexer
    private let source: String?
    private var tokens: [any Token]? = nil      // 未パースであれば null. パース開始以降0個以上の要素
    private var symbolTable: SymbolTable
    private var _rootNode: RootNode? = nil
    private var bracketStack: Stack<Node> = Stack<Node>()
       
    
    var rootNode: RootNode? {
        get {
            return _rootNode
        }
    }
    
    init(source: String) {
        self.source = source
        self.lexer = Lexer(source: source)
        self.symbolTable = SymbolTable()
    }
    
    init(lexer: Lexer) {
        self.source = nil
        self.lexer = lexer
        self.symbolTable = SymbolTable()
    }
    
    public func nodesDescription() -> String {
        guard let rootNode = self.rootNode else {
            return ""
        }
        let traverser = Traverser(rootNode: rootNode)
        // print(traverser.description)
        return traverser.description

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
        try _ = semanticAnalize()
        return self.rootNode!
    }
    
    private func parseWithTokens() throws {
        guard let curTokens = tokens else {
            throw ParseError.logical(message: "tokens is null")
        }
        curTokens.forEach{
            parseWithToken(token: $0)
        }
    }
    
    private func parseWithToken(token: any Token) {
        let node = NodeFactory.createNode(token: token)
        _ = insertNode(newNode: node)
    }
    
    private func semanticAnalize() throws -> SymbolTable {
        guard let rootNode = self.rootNode else {
            return SymbolTable()
        }
        let traverser = Traverser(rootNode: rootNode)
        /*
        var symbolTable = traverser.reduce(initialResult: SymbolTable(), closer:{ node, result in
            let symbolTalbe = insertOrUpdateSymbol(node: node, symbolTable: result)
            return symbolTalbe
        } )
         */
        var symbolTable = SymbolTable()
        traverser.forEachWithCloser(result: &symbolTable, closer: { node, result in
            _ = insertOrUpdateSymbol(node: node, symbolTable: result)
            return
        } )
        if symbolTable.invalidSymbols().count > 0 {
            //throw ParseError.symbolNotFound(symbolName: symbolTable.invalidSymbols()[0])
        }
        return symbolTable
    }
    
    private func insertOrUpdateSymbol(node: Node, symbolTable: SymbolTable) -> SymbolTable {
        if node.isSymbol {
            guard let token = node.token else {
                return symbolTable
            }
            if let symbolValue = symbolTable[token.string] {
                node.value = symbolValue
            }
            if !symbolTable.contains(symbol: token.string) {
                symbolTable.appendSymbol(symbol: token.string)
                if node.isLeftExpression {
                    if let parent = node.parent  {
                        node.value = parent.value
                    }
                    if node.value.isValid {
                        symbolTable[token.string] = node.value
                    }
                    else {
                        symbolTable[token.string] = NumericWrapper(value: Double.nan)
                    }
                }
            }
            if node.value.isValid {
                if !symbolTable.containsValue(symbol: token.string) {
                    symbolTable[token.string] = node.value
                }
            }
        }
        return symbolTable
    }
    
    private func insertNode(newNode: Node) -> Node? {
        var intertedNode: Node?
        if newNode.leftBrace {
            bracketStack.push(element: newNode)
        }
        else if newNode.rightBrace {
            let childNode: Node? = bracketStack.pop()
            let parentNode = bracketStack.isEmpty ? rootNode! : bracketStack.peek()!
            guard let node = childNode else {
                return nil
            }
            intertedNode = insertNodeAt(newNode: node, currentNode: parentNode, parentNode: nil)
        }
        else {
            let currentRootNode: Node
            if bracketStack.isEmpty {
                currentRootNode = rootNode!
            }
            else {
                currentRootNode = bracketStack.peek()!
            }
            intertedNode = insertNodeAt(newNode: newNode, currentNode: currentRootNode, parentNode: nil)
        }
        return intertedNode
    }
    
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
            if currentNode!.parent!.lhs == currentNode {
                currentNode!.parent!.lhs = newNode
            }
            else if currentNode!.parent!.rhs == currentNode {
                currentNode!.parent!.rhs = newNode
            }
            currentNode!.parent = newNode

            return newNode
        }
    }
}
