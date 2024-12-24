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
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            // 計算結果
            Text("結果")
                .font(.title)
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            Text(viewModel.stringValue)
                .font(.title)
                .border(Color.textBackColor)
                .frame(maxWidth: .infinity,
                       minHeight: 30,
                       alignment: .bottomTrailing)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 10.0, trailing: 10.0))
                .foregroundColor(Color.textColor)
                .background(Color.textBackColor)
            // 解析結果
            PolishNotationView(viewModel: self.viewModel)
            // 入力
            
            ExprInputView(viewModel: self.viewModel)
            
            Button(action:  { onOk() }, label: {
                Text("OK")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.textColor)
            })
        }
        .padding(.horizontal, 10.0)
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

