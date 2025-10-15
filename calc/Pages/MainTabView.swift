//
//  TabView.swift
//  calc
//
//  Created by nyaago on 2025/10/13.
//

import SwiftUI

struct MainTabView: View {
    
    enum SelectedTab: Int {
        case main = 0
        case bookmark = 1
    }

    @State private var selectedTab: SelectedTab = .main
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Main", systemImage: "square.and.pencil", value: SelectedTab.main) {
                MainView()
            }
            Tab("Bookmark", systemImage: "bookmark.square", value: SelectedTab.bookmark) {
                Text("Dummy")
                
            }
        }
    }
}

#Preview {
    MainTabView()
}
