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
    }
}

struct ExprVariablesView: View {
    var viewModel: CalcModel
    @Binding var exprVariables: [ExprVariable]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("変数一覧")
                .font(.title)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 5.0, trailing: 10.0))
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            List(exprVariables) { exprVariable in
                ExprVariableItemView(exprVariable: exprVariable)
            }
        }
    }
}
