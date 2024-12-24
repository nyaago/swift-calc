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

    var body: some View {
        Text("式を入力")
            .font(.title)
            .foregroundColor(Color.labelTextColor)
            .background(Color.labelBackColor)
        TextEditor(text: $editText)
            .keyboardType(.numbersAndPunctuation)
            .font(.title)
            .scrollContentBackground(Visibility.hidden)
            .border(Color.labelBackColor)
            .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                bottom: 10.0, trailing: 10.0))
            .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity,
                   minHeight: 30, idealHeight: 40, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                   alignment: .topTrailing)
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
}

#Preview {
    ExprInputView(viewModel: CalcModel())
        .preferredColorScheme(.dark)
}
