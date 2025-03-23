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
        VStack(alignment: .leading, spacing: 0) {
            Text("結果")
                .modifier(LabelTextModifier())
            Text(viewModel.stringValue)
                .modifier(SingleLineTextModifier())
        }
    }
}

#Preview {
    ResultView(viewModel: CalcModel())
        .preferredColorScheme(.dark)
}
