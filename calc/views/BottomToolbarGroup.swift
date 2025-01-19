//
//  BottomToolbar.swift
//  calc
//
//  Created by nyaago on 2025/01/18.
//
import SwiftUI

struct BottomToolbarGroup: View {
    var body: some View {
        NavigationStack {
            Text("Hello, SwiftUI!")
                .navigationTitle("Toolbar Example")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            print("Button 1 tapped")
                        }) {
                            Image(systemName: "star")
                        }
                        Button(action: {
                            print("Button 2 tapped")
                        }) {
                            Image(systemName: "heart")
                        }
                    }
                }
        }
    }}
