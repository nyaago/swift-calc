//
//  ContentView.swift
//  calc
//
//  Created by nyaago.
//

import SwiftUI

struct ContentView: View {
    enum DetailedViewType: Int {
        case polishNotation = 1
        case exprVariableList =  2
        case list3 = 3
    }
    
    @State var editText = ""
    @State var detailedViewType: DetailedViewType = .polishNotation
    var viewModel = CalcModel()
    @State var exprVariables: [ExprVariable] = []
    @FocusState var textEditorFocused: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                // 計算結果
                ResultView(viewModel: self.viewModel)
                // 入力
                ExprInputView(viewModel: self.viewModel, exprVariables:$exprVariables, textEditorFocused: self.$textEditorFocused)
                // 解析結果
                DetailResultView(viewModel: self.viewModel, detailedViewType: self.detailedViewType, exprVariables: $exprVariables )
                //deitaledResultView(viewModel: self.viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 10.0)
            .toolbar {
                toolbarContent
            }.background(Color.black)
        }
        .onTapGesture {
            textEditorFocused = false
        }
    }
    
    private var toolbarContent: some ToolbarContent  {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("Polish Notation", systemImage: "doc.text", action: {
                    self.detailedViewType = .polishNotation
                })
                Button("Variables", systemImage: "list.bullet.rectangle", action: {
                    self.detailedViewType = .exprVariableList
                })
            }
            label: { Label("", systemImage: "list.bullet")
            }
        }
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
