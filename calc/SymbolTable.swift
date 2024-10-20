//
//  Untitled.swift
//  calc
//
//  Created by nyaago on 2024/10/20.
//


// 変数をキーに数値を値にもつ単純な記号表
class SymbolTable: CustomStringConvertible {
   
    private var table: Dictionary<String, NumericWrapper>
    
    init() {
        table = Dictionary<String, NumericWrapper>()
    }
    
    subscript(symbol: String) -> NumericWrapper? {
        get {
            return table[symbol]
        }
        set(value) {
            table[symbol] = value
        }
    }
    
    func contains(symbol: String) -> Bool {
        return table.keys.contains { $0 == symbol }
    }
    func containsValue(symbol: String) -> Bool {
        guard let value = self[symbol] else {
            return false
        }
        return value.isValid
    }

    func appendSymbol(symbol: String) {
        table[symbol] = NumericWrapper(value:  Double.nan)
    }
    
    func invalidSymbols() -> [String] {
        var element = Array<String>()
        for key in table.keys {
            guard let value = table[key] else {
                element.append(key)
                continue
            }
            if value.isNotValid {
                element.append(key)
                continue
            }
        }
        return element
    }
    
    var description: String {
        get {
            var descElement = Array<String>()
            for key in table.keys {
                let value = table[key]?.stringValue
                let s = value ?? ""
                descElement.append("\(key)=\(s)")
            }
            return descElement.joined(separator: "/")
        }
    }
}
