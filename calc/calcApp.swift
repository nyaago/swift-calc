//
//  calcApp.swift
//  calc
//
//  Created by nyaago on 2021/03/24.
//

import SwiftUI
import SwiftData

@main
struct calcApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [FavoriteExpr.self])
        }
    }
}
