//
//  Lexer.swift
//  calc
//
//  Created by nyaago.
//

import Foundation

fileprivate extension UnicodeScalar {
    
    var isWhitespace: Bool {
        get {
            self == " " || self == "\t"
        }
    }
    
    var isExpressionSeparator: Bool {
        get {
            self == "\n" || self == "\r"
        }
    }
    
    var isNumber: Bool {
        get {
            let numChars = Set("0123456789".unicodeScalars)
            return numChars.contains(self)
        }
    }
    
    var isAlpha: Bool {
        get {
            let chars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".unicodeScalars)
            return chars.contains(self)
        }
    }
    
    var isPoint: Bool {
        get {
            let chars = Set(".".unicodeScalars)
            return chars.contains(self)
        }
    }

    var isLeftBracket: Bool {
        get {
            let chars = Set("({".unicodeScalars)
            return chars.contains(self)
        }
    }

    var isRightBracket: Bool {
        get {
            let chars = Set(")}".unicodeScalars)
            return chars.contains(self)
        }
    }

    var isNumeric: Bool {
        get {
            return isNumber || isPoint
        }
    }
    
    var isOperator: Bool {
        get {
            let chars = Set("+-*/=<>".unicodeScalars)
            return chars.contains(self)
        }
    }

    
    var isIdentifier: Bool {
        get {
            return isAlpha
        }
    }
}


public enum TokenKind: String {
    case `operator`
    case `leftBracket`
    case `rightBracket`
    case `numeric`
    case `integer`
    case `word`
    case `expressionSeparator`
}

public protocol Token: CustomStringConvertible {
    
    init(string: String)
    var string: String { get }
    var tokenKind: TokenKind { get }
}

public struct IntegerToken: Token {

    public let string: String
    public let tokenKind: TokenKind = .integer

    public init(string: String) {
        self.string = string
    }
    
    public var integerVal: Int? { Int(self.string) }
    public var description: String { return string }
}

public struct NumericToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .numeric

    public init(string: String) {
        self.string = string
    }

    public var integerVal: Int? { Int(self.string) }
    public var numeticVal: Double? { Double(self.string) }
    public var description: String { return string }
}

public struct OperatorToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .operator

    public init(string: String) {
        self.string = string
    }
    public var description: String { return string }
}

public struct LeftBracketToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .leftBracket

    public init(string: String) {
        self.string = string
    }
    public var description: String { return string }
}

public struct RightBracketToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .rightBracket

    public init(string: String) {
        self.string = string
    }
    public var description: String { return string }
}

public struct WordToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .word
    
    public init(string: String) {
        self.string = string
    }
    public var description: String { return string }
}

public struct ExpressionSeparatorToken: Token {
    public let string: String
    public let tokenKind: TokenKind = .expressionSeparator
    
    public init(string: String) {
        self.string = string
    }
    public var description: String { return string }
}

public enum LexerError: Error {
  case invalidString(String, Int)
  case unknown
}

public class Lexer: CustomStringConvertible {
    
    
    private let scanner: Scanner
    private var cachedTokens: [any Token]? = nil
    private var _errorMessages: [String] = []
    
    init(source: String) {
        self.scanner = Scanner(source: source)
    }
    
    /**
     - throws: LexerError
    */
    public var tokens:  [any Token]? {
        get {
            do {
                guard let unwrapedTokens = cachedTokens else {
                    if failed { // すでに analize されてエラーになっている
                        return nil
                    }
                    return try analize()
                }
                return unwrapedTokens
            }
            catch {
                return nil
            }
        }
    }
    
    public var failed: Bool {
        get {
            if errorMessages.count > 0 {
                return true
            }
            return false
        }
    }
    
    public var errorMessages: [String] {
        get {
            return _errorMessages
        }
    }

    public var errorMessage: String {
        get {
            return errorMessages.joined(separator: "\n")
        }
    }
    
    public var description: String {
        get {
            guard let tokens =  self.tokens else {
                return errorMessage
            }
            let descriptions: [String] = tokens.map { $0.description }
            return descriptions.joined(separator: " ")
        }
    }
    
    /**
     - throws: (unknown error - bug?)
     - returns: [Token]
    */
    public func analize() throws -> [any Token]  {
        cachedTokens = []
        while !scanner.isEnd {
            do {
                if let token: any Token = try nextToken() {
                    cachedTokens!.append(token)
                }
            }
            
            catch LexerError.invalidString(let string, let position) {
                _errorMessages.append("invalid string or charator '\(string)' at \(position)")
                // TODO 不正文字、とりあえず無視
                scanner.consume()
            }
            catch LexerError.unknown {
                _errorMessages.append("unknown error in lexical analizeing")
            }
            catch {
                _errorMessages.append("unknown error in lexical analizeing")
                throw error
            }
        }
        return cachedTokens!
    }
    
    /**
     - throws: LexerError
     - returns: Token? テキストの終わりであれば nil
    */
    public func nextToken() throws -> (any Token)? {
        while let char = scanner.currentChar, char.isWhitespace {
            scanner.consume()
        }
        switch scanner.currentChar {
        case .some(let char) where char.isNumeric:
            return numericToken()
        case .some(let char) where char.isOperator:
            return operatorToken()
        case .some(let char) where char.isLeftBracket:
            return leftBracketToken()
        case .some(let char) where char.isRightBracket:
            return rightBracketToken()
        case let .some(char) where char.isAlpha:
            return wordToken()
        case let .some(char) where char.isExpressionSeparator:
            return expressionSeparator()
        case let .some(char): // とりあえず想定外の文字なら例外にする
            throw LexerError.invalidString(String(char), scanner.currentPosition)
        default:
            throw LexerError.unknown // 不明のエラー = bug
        }
    }
    
    private func numericToken() -> any Token {
        let s = gatherWhile(condition: { $0.isNumeric })
        if s.contains(".") {
            return NumericToken(string: s)
        }
        else {
            return IntegerToken(string: s)
        }
    }
    
    public func operatorToken() -> any Token {
        let s = gatherWhile(condition: { $0.isOperator })
        return OperatorToken(string: s)
    }
    
    public func leftBracketToken() -> any Token {
        let s = gatherWhile(condition: { $0.isLeftBracket })
        return LeftBracketToken(string: s)
    }

    public func rightBracketToken() -> any Token {
        let s = gatherWhile(condition: { $0.isRightBracket })
        return RightBracketToken(string: s)
    }

    public func wordToken() -> any Token {
        let s = gatherWhile(condition: { $0.isAlpha || $0.isNumeric })
        return WordToken(string: s)
    }

    public func expressionSeparator() -> any Token {
        let s = gatherWhile(condition: { $0.isExpressionSeparator })
        return ExpressionSeparatorToken(string: s)
    }

    private func gatherWhile(condition: (UnicodeScalar) -> Bool ) -> String {
        var string: String = ""
        while let char = scanner.currentChar, condition(char) {
            string.append(String(char))
            scanner.consume()
        }
        return string
    }
}
