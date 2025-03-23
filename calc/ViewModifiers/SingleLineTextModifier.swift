//
//  SingleLineTextModifier.swift
//  calc
//
//  Created by nyaago on 2025/03/03.
//

import SwiftUICore
struct SingleLineTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .border(Color.textBackColor)
            .frame(maxWidth: .infinity,
                   minHeight: 20,
                   alignment: .topLeading)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 10.0, trailing: 10.0))
            .foregroundColor(Color.textColor)
            .background(Color.textBackColor)
    }
}
