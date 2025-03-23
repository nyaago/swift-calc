//
//  Stack.swift
//  calc
//
//  Created by nyaago on 2021/10/29.
//

import Foundation

protocol Stackable {
    associatedtype Element
    mutating func push(element: Element)
    mutating func pop() -> Element?
    var count: Int { get }
    var isEmpty:  Bool { get }
}

struct Stack<Element>: Stackable {
    private var array: [Element] = []
    
    init() {
            
    }
    
    mutating func push(element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        if isEmpty {
            return nil
        }
        return array.popLast()
    }
    
    func peek() -> Element? {
        if isEmpty {
            return nil
        }
        return array.last
    }
    
    var count: Int {
        get {
            return array.count
        }
    }
    
    var isEmpty: Bool {
        get {
            return self.count == 0
        }
    }
}
