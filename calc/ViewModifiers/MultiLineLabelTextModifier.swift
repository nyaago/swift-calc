//
//  MultiLineLabelTextModifier.swift
//  calc
//
//  Created by nyaago on 2025/11/17.
//

import SwiftUI

struct MultiLineLabelTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(Color.labelTextColor)
            .background(Color.labelBackColor)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 10.0, trailing: 10.0))
            .border(Color.textBackColor)
            .offset(x: 0.0, y: -0)
    }
}
