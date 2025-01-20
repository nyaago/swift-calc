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
    @FocusState.Binding var textEditorFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("式を入力")
                .font(.title)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 5.0, trailing: 10.0))
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            TextEditor(text: $editText)
                .focused(self.$textEditorFocused)
                .keyboardType(.numbersAndPunctuation)
                .font(.title)
                .scrollContentBackground(Visibility.hidden)
                .border(Color.labelBackColor)
                .padding(EdgeInsets(top: 5.0, leading: 10.0,
                                    bottom: 10.0, trailing: 10.0))
                .frame(maxWidth: .infinity,
                       minHeight: 150.0,
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
                }
        }
        .onTapGesture {
            self.textEditorFocused = false
        }
    }
}

 #Preview {
     @FocusState var focused: Bool
     ExprInputView(viewModel: CalcModel(), textEditorFocused: $focused)
         .preferredColorScheme(.dark)
 }
