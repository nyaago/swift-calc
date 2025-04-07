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
    var stringValue: String = ""
    var polishNotation: String = ""

    @ObservationIgnored private var parser: Parser?
    @ObservationIgnored private var lexer: Lexer?
    private var currentValue: NumericWrapper?
    
    init() {
    }
   
    func calc()  -> NumericWrapper? {
        guard let newExpr = self.expr else {
            return NumericWrapper(value: 0.0)
        }
        self.parser = Parser(source: newExpr)
        do {
            let _ = try parser!.parse()
        }
        catch let error as ParseError {
            self.stringValue = error.errorDescription ?? "error"
            return NumericWrapper(value: 0.0)
        }
        catch {
            self.stringValue = error.localizedDescription
            return NumericWrapper(value: 0.0)
        }
        
        if let rootNode = parser?.rootNode {
            if self.currentValue == rootNode.value {
                // 値が変わらなければ更新しない
                return NumericWrapper(value: 0.0)
            }
            if self.currentValue?.isNotValid ?? true && rootNode.value.isNotValid {
                // 無効値 -> 無効値なら更新しない
                return NumericWrapper(value: 0.0)
            }
            self.currentValue = rootNode.value
            self.stringValue = rootNode.value.stringValue
        }
        self.polishNotation = buildPolishNotation()
        return self.currentValue
    }
    
    var description: String {
        get {
            return buildPolishNotation()
        }
    }
    
    var symbolTable: SymbolTable? {
        return parser?.symbolTable
    }
    
    func buildPolishNotation() -> String {
        guard let parser = self.parser else {
            return ""
        }
        
        return parser.polishNotationString()
    }

    func lexerDescription() -> String {
        guard let curLexer = self.lexer else {
            return "Experation not input"
        }
        return curLexer.description
    }

    var tokens : [any Token]? {
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
