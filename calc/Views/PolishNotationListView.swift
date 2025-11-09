//
//  Polish.swift
//  calc
//
//  Created by nyaago on 2024/12/25.
//
import SwiftUI

struct PolishNotationRowView: View {
    var polishNotationExpr: PolishNotationExpr
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(polishNotationExpr.strtingValue)
                .font(.body)
                .frame(width: 60,
                       alignment: .leading)
            Text(polishNotationExpr.expr)
                .font(.body)
                .frame(maxWidth: .infinity,
                       minHeight: 12,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
        .modifier(ListItemViewModifier())
    }
}

struct PolishNotationListView: View {
    @Bindable var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(viewModel.polishNotationExpr) { identigablePolishNotionExpr in
                PolishNotationRowView(polishNotationExpr: identigablePolishNotionExpr)
                    .modifier(ListViewModifier())
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CalcModel = CalcModel(expr: "a = 5 * 6 \nb = a + 5")
    PolishNotationListView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}

