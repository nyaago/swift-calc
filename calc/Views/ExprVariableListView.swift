//
//  ExprVariableItemView.swift
//  calc
//
//  Created by nyaago on 2025/01/21.
//

import SwiftUI

struct ExprVariableRowView: View {
    var exprVariable: ExprVariable
    
    var body: some View {
        Text(exprVariable.listItemText)
            .font(.body)
            .listRowBackground(Color.textBackColor)
            .listRowSeparatorTint(Color.listRowSeparatorColor)
            .padding(EdgeInsets(top: 5, leading: 0,
                                bottom: 0, trailing: 0))
    }
}

struct ExprVariableListView: View {
    @Bindable var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(viewModel.exprVariables) { exprVariable in
                ExprVariableRowView(exprVariable: exprVariable)
                    .modifier(ListViewModifier())
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CalcModel = CalcModel(expr: "a = 5 * 6 \nb = a + 5")
    ExprVariableListView(viewModel: viewModel)
}

