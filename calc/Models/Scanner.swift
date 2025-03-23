//
//  Scanner.swift
//  calc
//
//  Created by nyaago.
//

import Foundation

class Scanner {
    private let source: [UnicodeScalar]
    
    private var position: Int = 0
    
    
    init(source: String) {
        self.source = Array(source.unicodeScalars)
        self.position = self.source.startIndex
    }
    
    var currentChar: UnicodeScalar? {
        get {
            guard position < source.count else {
                return nil
            }
            return source[position]
        }
    }
    
    var isEnd: Bool {
        get {
            return position >= source.count
        }
    }
    
    var currentPosition: Int {
        get {
            return position
        }
    }
    
    func consume() {
        position += 1
    }
}
