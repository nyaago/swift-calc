//
//  CalcModel.swift
//  calc
//
//  Created by nyaago on.
//

import Foundation
import Observation

@Observable class CalcModel: CustomStringConvertible {
    
    var expr: String?
    var exprVariables: [ExprVariable] = []
    var polishNotationExpr: [PolishNotationExpr] = []
    
    var sentenceNodesWrapper: [SentenceNodeWrapper] = []
    var currentValue: NumericWrapper?
    var error: (any Error)?

    @ObservationIgnored private var sentenceNodes: [SentenceNode] = []
    @ObservationIgnored private var parser: Parser?
    @ObservationIgnored private var lexer: Lexer?
    
    init() {
        
    }
    
    init(expr: String) {
        self.expr = expr
        calc()
    }
    
    var stringValue: String {
        get {
            if let _ = self.error {
                return ""
            }
            return currentValue?.stringValue ?? ""
        }
    }
    
    @discardableResult
    func calc()  -> NumericWrapper? {
        self.error = nil
        guard let newExpr = self.expr else {
            return NumericWrapper(value: 0.0)
        }
        self.parser = Parser(source: newExpr)
        return _calc()
    }
    
    var symbolTable: SymbolTable? {
        return parser?.symbolTable
    }
    
    //
    @discardableResult
    func replaceSentenceBySentence(index: Int, sentence: String) throws  -> NumericWrapper?  {
        let replacedNode = sentenceNodes[index]
        let parser = Parser(source: sentence)
        try parser.parse()
        if parser.sentences.isEmpty {
            return currentValue
        }
        let newSentence: SentenceNode = parser.sentences[0]
        let newSentences = sentenceNodes.map { node in
            if replacedNode == node {
                return newSentence
            }
            else {
                return node
            }
        }
        self.parser = Parser(sentenceNodes: newSentences)
        let value = _calc()
        self.expr = self.parser?.rootNode?.text
        return value
    }
    
    @discardableResult
    func appendSentence(sentence: String) throws -> NumericWrapper? {
        let parser = Parser(source: sentence)
        try parser.parse()
        if parser.sentences.isEmpty {
            return currentValue
        }
        let newSentence: SentenceNode = parser.sentences[0]
        var newSentences = self.sentenceNodes
        newSentences.append(newSentence)
        self.parser = Parser(sentenceNodes: newSentences)
        let value = _calc()
        self.expr = self.parser?.rootNode?.text
        return value
    }
    
    @discardableResult
    func moveSentence(from: Int, to: Int)  throws -> NumericWrapper? {
        var newSentences = self.sentenceNodes
        newSentences.swapAt(from, to)
        self.parser = Parser(sentenceNodes: newSentences)
        let value = _calc()
        self.expr = self.parser?.rootNode?.text
        return value
    }

    @discardableResult
    func deleteSentence(index: Int) throws -> NumericWrapper? {
        var newSentences = self.sentenceNodes
        newSentences.remove(at: index)
        self.parser = Parser(sentenceNodes: newSentences)
        let value = _calc()
        self.expr = self.parser?.rootNode?.text
        return value
    }
    
    private func _calc()  -> NumericWrapper? {
        self.error = nil
        do {
            let _ = try parser!.parse()
        }
        catch let error as ParseError {
            self.error = error
            return NumericWrapper(value: 0.0)
        }
        catch let error  {
            self.error = error
            return NumericWrapper(value: 0.0)
        }
        
        if let rootNode = parser?.rootNode {
            if self.currentValue?.isNotValid ?? true && rootNode.value.isNotValid {
                // 無効値 -> 無効値なら更新しない
                return NumericWrapper(value: 0.0)
            }
            self.currentValue = rootNode.value
        }
        self.sentenceNodes = buildSentenceNodes()
        self.exprVariables = buildExprVariables()
        self.polishNotationExpr = buildPolishNotationExprs()
        self.sentenceNodesWrapper = buildIdentifiableSentenceNodes()
        return self.currentValue
    }
    
    func buildPolishNotationExprs() -> [PolishNotationExpr] {
        
        return sentenceNodes.map { sentenceNode in
            PolishNotationExpr(sentenceNode: sentenceNode) }
    }
    
    func buildPolishNotationString() -> String {
        guard let parser = self.parser else {
            return ""
        }
        
        return parser.polishNotationString()
    }
    
    private func buildExprVariables() -> [ExprVariable] {
        guard let symbolTable = symbolTable else {
            return []
        }
        return symbolTable.asArray.map { symbolElement in
            ExprVariable(name: symbolElement.name, value: symbolElement.value)
        }
    }
    
    private func buildIdentifiableSentenceNodes() -> [SentenceNodeWrapper] {
        sentenceNodes.map { sentenceNode in
            SentenceNodeWrapper(sentenceNode: sentenceNode)
        }
    }
    
    private func buildSentenceNodes() -> [SentenceNode] {
        guard let parser = self.parser else {
            return []
        }
        return parser.sentences
    }

    
    @ObservationIgnored var description: String {
        get {
            return buildPolishNotationString()
        }
    }

    @ObservationIgnored var  lexerDescription:  String {
        guard let curLexer = self.lexer else {
            return "Experation not input"
        }
        return curLexer.description
    }

    @ObservationIgnored var tokens : [any Token]? {
        get  {
            guard let curLexer = self.lexer else {
                return []
            }
            return curLexer.tokens
        }
    }
}
