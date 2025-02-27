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
                .font(.headline)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 5.0, trailing: 10.0))
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            TextEditor(text: $editText)
                .focused(self.$textEditorFocused)
                .keyboardType(.numbersAndPunctuation)
                .font(.body)
                .scrollContentBackground(Visibility.hidden)
                .border(Color.labelBackColor)
                .padding(EdgeInsets(top: 0.0, leading: 0.0,
                                    bottom: 0.0, trailing: 0.0))
                .frame(maxWidth: .infinity,
                       minHeight: 50.0,
                       maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                       alignment: .topLeading)
                .offset(x: 0.0, y: -0)
                .foregroundColor(Color.textColor)
                .background(Color.editTextBackColor)
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
