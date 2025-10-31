//
//  NumericWrapper.swift
//  calc
//
//  Created by nyaago on 2024/10/06.
//

import Foundation

enum NumericWrapperType: Int8 {
    case Double = 1
    case Int  = 2
}

enum NumericWrapperErrorType: Int8, CustomStringConvertible {
    case devideByZero = 1
    case incompletedExpression = 2
    case other = 127
    
    var description: String {
        get {
            switch self {
            case .devideByZero:
                return "devided by zero"
            case .incompletedExpression:
                return "incompleted expression"
            default:
                return "some error occured"
            }
        }
    }
}

struct NumericWrapper: SignedNumeric, Comparable, CustomStringConvertible {
       
    
    static private let maxOfInt = Double(Int64.max)
    static private let minOfInt = Double(Int64.min)
    static private let invalidValue = NumericWrapper(value: Double.nan)
    
    typealias IntegerLiteralType = Int64
    typealias Magnitude = Double

    private var _valueType: NumericWrapperType
    private var _value: Double?
    private var _errorType: NumericWrapperErrorType?
    
    var description: String {
        get {
            return stringValue
        }
    }
    
    var valueType: NumericWrapperType {
        get {
            return _valueType
        }
    }
    
    var value: Double {
        get {
            return _value ?? Double.nan
        }
    }
        
    var intValue: Int64 {
        get {
            if value > Self.maxOfInt || value < Self.minOfInt {
                return Int64(value)
            }
            return Int64(value)
        }
    }
    
    var errotType: NumericWrapperErrorType? {
        get {
            return _errorType
        }
    }
    
    var magnitude: Double {
        get {
            return value.magnitude
        }
    }
    
    var stringValue: String {
        get {
            if isNotValid {
                guard let _ = self.errotType else {
                    return "?"
                }
                return "?"
            }
            if valueType == .Double {
                return String(value)
            }
            else {
                return String(intValue)
            }
        }
    }
    
    var isValid: Bool {
        get {
            guard let currentValue = _value else {
                return false
            }
            if currentValue.isNaN {
                return false
            }
            return true
        }
    }
    
    var isNotValid: Bool {
        get {
            return !isValid
        }
    }
    
    init(integerLiteral value: Int64) {
        self._value = Double(exactly: value)
        self._valueType = .Int
    }
    
    
    init(value: Double) {
        self._value = value
        self._valueType = .Double
        if value.isNaN {
            self._errorType = .incompletedExpression
        }
    }

    init(value: Int64) {
        self._value = Double(value)
        self._valueType = .Int
    }
    
    init(errorType: NumericWrapperErrorType) {
        self._value = Self.invalidValue.value
        self._valueType = .Double
        self._errorType = errorType
    }

    init?<T>(exactly source: T) where T : BinaryInteger {
        self._value = Double(source)
        self._valueType = .Int
    }

    static func - (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
        if lhs.isNotValid  {
            return NumericWrapper(errorType: lhs._errorType ?? NumericWrapperErrorType.other)
        }
        if rhs.isNotValid  {
            return NumericWrapper(errorType: rhs._errorType ?? NumericWrapperErrorType.other)
        }
        let newValue =  NumericWrapper(value: lhs.value - rhs.value)
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return newValue
        }
        if newValue.value > Self.maxOfInt || newValue.value < Self.minOfInt {
            return newValue
        }
        return NumericWrapper(value: newValue.intValue)
    }
    
    static func *= (lhs: inout NumericWrapper, rhs: NumericWrapper) {
        if lhs.isNotValid || rhs.isNotValid {
            return;
        }

        let newValue = lhs.value * rhs.value
        if lhs._valueType == .Double || rhs._valueType == .Double {
            lhs._value = newValue
        }
        else {
            if lhs.value > Self.maxOfInt || lhs.value < Self.minOfInt {
                // do nothing
            }
            else {
                lhs._valueType = .Int
            }
        }
    }

    static func < (lhs: NumericWrapper, rhs: NumericWrapper) -> Bool {
        if lhs.isNotValid || rhs.isNotValid {
            return false;
        }
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return lhs.value < rhs.value
        }
        else {
            return  Int64(lhs.value) < Int64(rhs.value)
        }
    }
    
    static func * (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
        if lhs.isNotValid  {
            return NumericWrapper(errorType: lhs._errorType ?? NumericWrapperErrorType.other)
        }
        if rhs.isNotValid  {
            return NumericWrapper(errorType: rhs._errorType ?? NumericWrapperErrorType.other)
        }
        let newValue = NumericWrapper(value: lhs.value * rhs.value)
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return newValue
        }
        else {
            if newValue.value > Self.maxOfInt || newValue.value < Self.minOfInt {
                return newValue
            }
            return NumericWrapper(value: newValue.intValue)
        }
    }

    static func / (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
        if lhs.isNotValid  {
            return NumericWrapper(errorType: lhs._errorType ?? NumericWrapperErrorType.other)
        }
        if rhs.isNotValid  {
            return NumericWrapper(errorType: rhs._errorType ?? NumericWrapperErrorType.other)
        }
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return NumericWrapper(value: lhs.value / rhs.value)
        }
        else {
            if rhs.value.isNaN {
                return NumericWrapper(errorType: .incompletedExpression)
            }
            if rhs.intValue == 0 {
                return NumericWrapper(errorType: .devideByZero)
            }
            return NumericWrapper(value: lhs.intValue / rhs.intValue)
        }
    }

    static func + (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
        if lhs.isNotValid  {
            return NumericWrapper(errorType: lhs._errorType ?? NumericWrapperErrorType.other)
        }
        if rhs.isNotValid  {
            return NumericWrapper(errorType: rhs._errorType ?? NumericWrapperErrorType.other)
        }
        let newValue = NumericWrapper(value: lhs.value + rhs.value)
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return newValue
        }
        if newValue.value > Self.maxOfInt || newValue.value < Self.minOfInt {
            return newValue
        }
        return NumericWrapper(value: newValue.intValue)
    }
}
