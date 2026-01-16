//
//  FavoriteExpr.swift
//  calc
//
//  Created by nyaago on 2025/11/12.
//

import Foundation
import SwiftData

@Model
final class FavoriteExpr {
    var expr: String
    var regsterdAt: Date
    var updatedAt: Date
    var title: String
    
    init (expr: String, title: String) {
        self.expr = expr
        self.title = title
        regsterdAt = Date()
        updatedAt = Date()
    }
}
