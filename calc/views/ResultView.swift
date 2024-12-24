//
//  ResultView.swift
//  calc
//
//  Created by nyaago on 2024/12/25.
//

import SwiftUI

struct ResultView: View {
    var viewModel: CalcModel
    
    var body: some View {
        Text("結果")
            .font(.title)
            .foregroundColor(Color.labelTextColor)
            .background(Color.labelBackColor)
        Text(viewModel.stringValue)
            .font(.title)
            .border(Color.textBackColor)
            .frame(maxWidth: .infinity,
                   minHeight: 30,
                   alignment: .bottomTrailing)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 10.0, trailing: 10.0))
            .foregroundColor(Color.textColor)
            .background(Color.textBackColor)
    }
}

#Preview {
    ResultView(viewModel: CalcModel())
        .preferredColorScheme(.dark)
}
