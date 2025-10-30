//
//  Untitled.swift
//  calc
//
//  Created by nyaago on 2024/10/20.
//


// 変数をキーに数値を値にもつ単純な記号表

struct SymbolElement {
    let name: String
    let value: NumericWrapper
    let seqNumber: Int
}

class SymbolTable: CustomStringConvertible {
   
    private var table: Dictionary<String, SymbolElement>
    private var seqNumber: Int = 1
    
    init() {
        table = Dictionary<String, SymbolElement>()
    }
    
    subscript(symbol: String) -> SymbolElement? {
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
        guard let element = self[symbol] else {
            return false
        }
        return element.value.isValid
    }
    
    @discardableResult
    func assignSymbolValue(symbol: String, value: NumericWrapper) -> SymbolElement {
        let element = SymbolElement(name: symbol, value: value, seqNumber: self.seqNumber)
        seqNumber += 1
        self[symbol] = element
        return table[symbol]!
    }
 
    @discardableResult
    func appendSymbol(symbol: String) -> SymbolElement {
        let value = NumericWrapper(value:  Double.nan)
        return assignSymbolValue(symbol: symbol, value: value)
    }
    
    func invalidSymbols() -> [String] {
        var symbols = Array<String>()
        for key in table.keys {
            guard let element = table[key] else {
                symbols.append(key)
                continue
            }
            if element.value.isNotValid {
                symbols.append(key)
                continue
            }
        }
        return symbols
    }
    
    var asArray: [SymbolElement] {
        get {
            return Array(table.values.sorted(by: { a, b in
                a.seqNumber > b.seqNumber
            }))
        }
    }
    
    var count: Int {
        get {
            table.count
        }
    }
    
    var isEmpty: Bool {
        get {
            count == 0
        }
    }
    
    var description: String {
        get {
            var descArray = Array<String>()
            for key in table.keys {
                let value = table[key]?.value.stringValue
                let s = value ?? ""
                descArray.append("\(key)=\(s)")
            }
            return descArray.joined(separator: "/")
        }
    }
}
