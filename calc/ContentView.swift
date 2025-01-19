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
        NavigationView {
            VStack(alignment: .leading, spacing: 10.0) {
                // 計算結果
                ResultView(viewModel: self.viewModel)
                // 入力
                ExprInputView(viewModel: self.viewModel)
                // 解析結果
                PolishNotationView(viewModel: self.viewModel)
            }
            .padding(.horizontal, 10.0)
            .padding(.bottom, 20.0)
            .toolbar {
                itemGroup
            }.background(Color.black)
        }
    }
    
    private var itemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {

            Spacer()
            Button(action: {
                print("Button 1 tapped")
            }) {
                Image(systemName: "doc.text")
            }
            Spacer()
            Button(action: {
                print("Button 2 tapped")
            }) {
                Image(systemName: "list.bullet.rectangle")
            }
            Spacer()
            Button(action: {
                print("Button 3 tapped")
            }) {
                Image(systemName: "info")
            }
            Spacer()
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

