//
//  DetailResultView.swift
//  calc
//
//  Created by nyaago on 2025/01/27.
//

import SwiftUI

struct DetailResultView: View {
    var viewModel: CalcModel
    var detailedViewType: ContentView.DetailedViewType = .polishNotation
    @Binding var exprVariables: [ExprVariable]
    
    var body: some View {
        AnyView( buildDeitaledResultView(viewModel: viewModel) )
    }

    private func buildDeitaledResultView(viewModel: CalcModel) -> any View {
        switch ( self.detailedViewType ) {
        case .polishNotation:
            return PolishNotationView(viewModel: viewModel)
        case .exprVariableList:
            return ExprVariablesView(viewModel: viewModel, exprVariables: $exprVariables)
        case .list3:
            return DummyTextView(viewModel:viewModel)
        }
    }

}
