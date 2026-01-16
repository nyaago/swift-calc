//
//  FavoriteListView.swift
//  calc
//
//  Created by nyaago on 2025/11/24.
//

import SwiftUI
import SwiftData


struct FavoriteRowView: View {
    @Bindable var favoriteExpr: FavoriteExpr
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(favoriteExpr.title)
                .font(.body)
                .frame(maxWidth: .infinity,
                       minHeight: 12,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
        .modifier(ListItemViewModifier())
    }
}


struct FavoriteListView: View {
    @Environment(\.modelContext) private var context
    @Query private var favoriteExprs: [FavoriteExpr]
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(favoriteExprs) { favoriteExpr in
                        NavigationLink(value: favoriteExpr) {
                            FavoriteRowView(favoriteExpr: favoriteExpr)
                        }
                    }
                }
                .navigationDestination(for: FavoriteExpr.self) { favoriteExprs in
                    
                }
            }
        }
    }
}

#Preview {
    FavoriteListView()
}
