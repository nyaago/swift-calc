//
//  ListViewModifier.swift
//  calc
//
//  Created by nyaago on 2025/03/03.
//

import SwiftUICore
struct ListViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .font(.body)
            .background(Color.textBackColor)
            .padding(EdgeInsets(top: 0, leading: 0,
                                bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity,
                   minHeight: 10,
                   maxHeight: .infinity,
                   alignment: .leading)
    }
}
