//
//  ExprInputView.swift
//  calc
//
//  Created by nyaago on 2024/12/17.
//

import SwiftUI

struct ExprInputView: View {
    @State var editText = ""
    var viewModel: CalcModel
    @Binding var exprVariables: [ExprVariable]
    @FocusState.Binding var textEditorFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("式を入力")
                .modifier(LabelTextModifier())
            TextEditor(text: $editText)
                .focused(self.$textEditorFocused)
                .keyboardType(.numbersAndPunctuation)
                .scrollContentBackground(Visibility.hidden)
                .modifier(MultiLineTextModifier())
                .frame(maxWidth: .infinity,
                       minHeight: 50.0,
                       maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                       alignment: .topLeading)
                .onAppear() {
                    // UIApplication.shared.closeKeyboard()
                }.onChange(of: self.editText) { oldText, newText in
                    viewModel.expr = newText
                    _ = viewModel.calc()
                    self.exprVariables = buildExprVariables()
                    // exprVariables =
                }
        }
        .onTapGesture {
            self.textEditorFocused = false
        }
    }
    private func buildExprVariables() -> [ExprVariable] {
        guard let symbolTable = viewModel.symbolTable else {
            return []
        }
        return symbolTable.asArray.map { symbolElement in
            ExprVariable(name: symbolElement.name, value: symbolElement.value)
        }
    }

}

 #Preview {
     @Previewable @State var exprVariables: [ExprVariable] = []
     @FocusState var focused: Bool
     ExprInputView(viewModel: CalcModel(), exprVariables:$exprVariables, textEditorFocused: $focused)
         .preferredColorScheme(.dark)
 }
