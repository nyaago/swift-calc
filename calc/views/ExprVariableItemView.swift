//
//  ExprVariableItemView.swift
//  calc
//
//  Created by nyaago on 2025/01/21.
//

import SwiftUI

struct ExprVariableItemView: View {
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

struct ExprVariablesView: View {
    var viewModel: CalcModel
    @Binding var exprVariables: [ExprVariable]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(exprVariables) { exprVariable in
                ExprVariableItemView(exprVariable: exprVariable)
                    .modifier(ListViewModifier())
            }
        }
    }
}
