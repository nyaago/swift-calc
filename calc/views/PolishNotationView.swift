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
        Text("前置記法表示")
            .font(.title)
            .foregroundColor(Color.labelTextColor)
            .background(Color.labelBackColor)
        ScrollView(.vertical, showsIndicators: true) {
            Text(viewModel.polishNotation)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .font(.title)
                .border(Color.labelBackColor)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 10.0, trailing: 10.0))
                .frame(maxWidth: .infinity,
                       minHeight: 50,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .foregroundColor(Color.textColor)
                .background(Color.textBackColor)
                .offset(x: 0.0, y: -0)
        }
        .frame(maxWidth: .infinity,
               maxHeight: 130)
        .background(Color.textBackColor)
    }
}

#Preview {
    PolishNotationView(viewModel: CalcModel())
        .preferredColorScheme(.dark)
}

