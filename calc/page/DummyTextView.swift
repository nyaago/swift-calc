//
//  DummyView.swift
//  calc
//
//  Created by nyaago on 2025/01/19.
//

import SwiftUI

struct DummyTextView: View {
    var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Dummy")
                .modifier(LabelTextModifier())
            Text(viewModel.stringValue)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .modifier(MultiLineTextModifier())
                .frame(maxWidth: .infinity,
                       minHeight: 50,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
    }
}
