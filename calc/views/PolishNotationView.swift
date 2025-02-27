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
                    .font(.body)
                    .border(Color.labelBackColor)
                    .padding(EdgeInsets(top: 0, leading: 0,
                                        bottom: 0, trailing: 0))
                    .frame(maxWidth: .infinity,
                           minHeight: 50,
                           maxHeight: .infinity,
                           alignment: .topLeading)
                    .foregroundColor(Color.textColor)
                    .background(Color.textBackColor)
                    .offset(x: 0.0, y: -0)
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

