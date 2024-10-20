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
            Text("解析木プレビュー")
                .font(.title)
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            ScrollView(.vertical, showsIndicators: true) {
                Text(viewModel.nodeDescription)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .font(.title)
                    .border(Color.labelBackColor)
                    .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                        bottom: 10.0, trailing: 10.0))
                    .frame(maxWidth: .infinity,
                           minHeight: 50,
                           maxHeight: .infinity,
                           alignment: .topLeading)
                    .foregroundColor(Color.textColor)
                    .background(Color.textBackColor)
                    .offset(x: 0.0, y: -0)
            }
            .frame(maxWidth: .infinity,
                   maxHeight: 130)
            .background(Color.textBackColor)
            // 入力
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
                    print("OnAppear")
                }
                .onChange(of: self.editText) { oldText, newText in
                    print("OnChange")
                    viewModel.expr = newText
                    _ = viewModel.calc()
                }
            
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

