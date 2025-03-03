//
//  DetailResultView.swift
//  calc
//
//  Created by nyaago on 2025/01/27.
//

import SwiftUI

struct DetailResultView: View {
    
    enum DetailedViewType: Int {
        case polishNotation = 1
        case exprVariableList =  2
    }

    
    var viewModel: CalcModel

    @State var detailedViewType: DetailedViewType = .polishNotation
    @Binding var exprVariables: [ExprVariable]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text(labelText)
                    .modifier(LabelTextModifier())
                Spacer()
            }
            .overlay(alignment: .bottomTrailing) {
                resultTypeMenu
                    .frame(maxHeight: .infinity,
                           alignment: .bottomTrailing)
                    .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                        bottom: 5.0, trailing: 10.0))
            }
            AnyView( buildDeitaledResultView(viewModel: viewModel) )
                .frame(maxWidth: .infinity,
                       minHeight: 50,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
    }

    private func buildDeitaledResultView(viewModel: CalcModel) -> any View {
        switch ( self.detailedViewType ) {
        case .polishNotation:
            return PolishNotationView(viewModel: viewModel)
        case .exprVariableList:
            return ExprVariablesView(viewModel: viewModel, exprVariables: $exprVariables)
        }
    }
    
    private var labelText: String {
        get {
            switch ( self.detailedViewType ) {
            case .polishNotation:
                return "Polish Notation"
            case .exprVariableList:
                return "Expr Varible List"
            }
        }
    }
    
    private var resultTypeMenu: some View {
        return Menu {
            Button("Polish Notation", systemImage: "doc.text", action: {
                self.detailedViewType = .polishNotation
            })
            .disabled(detailedViewType == .polishNotation)
            Button("Variables", systemImage: "list.bullet.rectangle", action: {
                self.detailedViewType = .exprVariableList
            })
            .disabled(detailedViewType == .exprVariableList)
        }
        label: { Label("Change", systemImage: "list.bullet")
        }
    }


}
