//
//  LabelTextModifier.swift
//  calc
//
//  Created by nyaago on 2025/03/03.
//

import SwiftUICore
struct LabelTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 5.0, trailing: 10.0))
            .foregroundColor(Color.labelTextColor)
            .background(Color.labelBackColor)
            .offset(x: 0.0, y: -0)
    }
}
