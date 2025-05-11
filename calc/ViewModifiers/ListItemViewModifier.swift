//
//  ListItemViewModifier.swift
//  calc
//
//  Created by nyaago on 2025/04/09.
//

import SwiftUICore
struct ListItemViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .listRowBackground(Color.textBackColor)
            .listRowSeparatorTint(Color.listRowSeparatorColor)
            .padding(EdgeInsets(top: 5, leading: 0,
                                bottom: 0, trailing: 0))
    }
}
