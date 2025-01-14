//
//  ContentView.swift
//  calc
//
//  Created by nyaago.
//

import SwiftUI

struct ContentView: View {
    @State var editText = ""
    var viewModel = CalcModel()
    @FocusState var textEditorFocused: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10.0) {
            // 計算結果
            ResultView(viewModel: self.viewModel)
            // 入力
            ExprInputView(viewModel: self.viewModel, textEditorFocused: self.$textEditorFocused)
            // 解析結果
            PolishNotationView(viewModel: self.viewModel)

            Button(action:  { onOk() }, label: {
                Text("OK")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.textColor)
            })
        }
        .padding(.horizontal, 10.0)
        .onTapGesture {
            textEditorFocused = false
        }
    }
    
    func onOk() {
        // viewModel.expr = self.editText
        // _ = viewModel.calc()
        // print(self.viewModel.lexerDescription())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}


extension UIApplication {
    func closeKeyboard() {
        // sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

