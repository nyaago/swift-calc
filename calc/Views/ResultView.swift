//
//  ResultView.swift
//  calc
//
//  Created by nyaago on 2024/12/25.
//

import SwiftUI

struct ResultView: View {
    @Binding var viewModel: CalcModel
    
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
    @State @Previewable var calcModel: CalcModel = CalcModel()
    ResultView(viewModel: $calcModel)
        .preferredColorScheme(.dark)
}
