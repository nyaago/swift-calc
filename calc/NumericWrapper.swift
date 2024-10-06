//
//  NumericWrapper.swift
//  calc
//
//  Created by nyaago on 2024/10/06.
//

import Foundation

enum NumericWrapperType {
    case Double
    case Int
}

struct NumericWrapper: SignedNumeric, Comparable {
    
    static private let maxOfInt = Double(Int64.max)
    static private let minOfInt = Double(Int64.min)
    
    typealias IntegerLiteralType = Int64
    typealias Magnitude = Double

    private var _valueType: NumericWrapperType
    private var _value: Double?
    
    
    
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
    
    var magnitude: Double {
        get {
            return value.magnitude
        }
    }
    
    var stringValue: String {
        get {
            if valueType == .Double {
                return String(value)
            }
            else {
                return String(intValue)
            }
        }
    }
    
    init(integerLiteral value: Int64) {
        self._value = Double(exactly: value)
        self._valueType = .Int
    }
    
    
    init(value: Double) {
        self._value = value
        self._valueType = .Double
    }

    init(value: Int64) {
        self._value = Double(value)
        self._valueType = .Int
    }

    init?<T>(exactly source: T) where T : BinaryInteger {
        self._value = Double(source)
        self._valueType = .Int
    }

    static func - (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
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
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return lhs.value < rhs.value
        }
        else {
            return  Int64(lhs.value) < Int64(rhs.value)
        }
    }
    
    static func * (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
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
        if lhs._valueType == .Double || rhs._valueType == .Double {
            return NumericWrapper(value: lhs.value / rhs.value)
        }
        else {
            return NumericWrapper(value: lhs.intValue / rhs.intValue)
        }
    }

    static func + (lhs: NumericWrapper, rhs: NumericWrapper) -> NumericWrapper {
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
