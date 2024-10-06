//
//  CalcModel.swift
//  calc
//
//  Created by nyaago on.
//

import Foundation

@Observable class CalcModel: ObservableObject, CustomStringConvertible {
    
    var expr: String?
    private var parser: Parser?
    private var lexer: Lexer?
    
    init() {
    }
   
    func calc()  -> Double {
        guard let newExpr = self.expr else {
            return 0.0
        }
        self.parser = Parser(source: newExpr)
        do {
            let rootNode = try parser!.parse()
        }
        catch {
            return 0.0
        }
        return 0.0  // TODO 計算結果
    }
    
    var description: String {
        get {
            return nodeDescription
        }
    }
    
    var nodeDescription: String {
        get {
            guard let parser = self.parser else {
                return ""
            }
            
            return parser.nodesDescription()
        }
    }

    func lexerDescription() -> String {
        guard let curLexer = self.lexer else {
            return "Experation not input"
        }
        return curLexer.description
    }

    var tokens : [Token]? {
        get  {
            guard let curLexer = self.lexer else {
                return []
            }
            return curLexer.tokens
        }
    }
    
    var stringValue: String {
        get {
            if let rootNode = parser?.rootNode {
                return rootNode.value.stringValue
            }
            return ""
        }
    }
    
    func toInt() -> Int {
        let v = calc()
        return Int(v)
    }
   
    func toIntString() -> String {
        let v = toInt()
        return String(v)
    }
}
