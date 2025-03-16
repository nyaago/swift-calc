//
//  Polish.swift
//  calc
//
//  Created by nyaago on 2024/12/25.
//
import SwiftUI

struct PolishNotationView: View {
    var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView(.vertical, showsIndicators: true) {
                Text(viewModel.polishNotation)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .modifier(MultiLineTextModifier())
                    .frame(maxWidth: .infinity,
                           minHeight: 50,
                           maxHeight: .infinity,
                           alignment: .topLeading)
            }
            .frame(maxWidth: .infinity,
                   minHeight: 50,
                   maxHeight: .infinity)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 10.0, trailing: 10.0))
            .background(Color.textBackColor)
        }
    }
}

#Preview {
    PolishNotationView(viewModel: CalcModel())
        .preferredColorScheme(.dark)
}

