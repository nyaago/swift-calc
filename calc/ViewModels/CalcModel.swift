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
    var sentenceNodes: [SentenceNode] = []
    var identifiableSentenceNodes: [IdentifiableSentenceNode] = []
    var currentValue: NumericWrapper?
    var error: (any Error)?

    @ObservationIgnored private var parser: Parser?
    @ObservationIgnored private var lexer: Lexer?
    
    var stringValue: String {
        get {
            if let _ = self.error {
                return ""
            }
            return currentValue?.stringValue ?? ""
        }
    }
    
    init() {
    }
   
    @discardableResult
    func calc()  -> NumericWrapper? {
        self.error = nil
        guard let newExpr = self.expr else {
            return NumericWrapper(value: 0.0)
        }
        self.parser = Parser(source: newExpr)
        do {
            let _ = try parser!.parse()
        }
        catch let error as ParseError {
            self.error = error
            //self.stringValue = error.errorDescription ?? "error"
            return NumericWrapper(value: 0.0)
        }
        catch let error  {
            self.error = error
            //self.stringValue = error.localizedDescription
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
        self.identifiableSentenceNodes = buildIdentifiableSentenceNodes()
        return self.currentValue
    }
    
   
    var symbolTable: SymbolTable? {
        return parser?.symbolTable
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
    
    private func buildIdentifiableSentenceNodes() -> [IdentifiableSentenceNode] {
        sentenceNodes.map { sentenceNode in
            IdentifiableSentenceNode(sentenceNode: sentenceNode)
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
    
    /*
    var stringValue: String {
        get {
            if let rootNode = parser?.rootNode {
                return rootNode.value.stringValue
            }
            return ""
        }
    }
     */
    
    /*
    func toInt() -> Int {
        let v = calc()
        return Int(v)
    }
   
    func toIntString() -> String {
        let v = toInt()
        return String(v)
    }
     */
}
