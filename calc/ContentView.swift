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
    @State var exprVariables: [ExprVariable] = []
    @State var showDummySheet: Bool = false
    @FocusState var textEditorFocused: Bool
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                // 計算結果
                ResultView(viewModel: self.viewModel)
                // 入力
                ExprInputView(viewModel: self.viewModel,
                              exprVariables:$exprVariables,
                              textEditorFocused: self.$textEditorFocused)
                // 解析結果
                DetailResultView(viewModel: self.viewModel,
                                 exprVariables: $exprVariables )
                //deitaledResultView(viewModel: self.viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 10.0)
            .toolbar {
                toolbarContent
            }
            .background(Color.black)
            .navigationTitle("Home")            // ナビゲーションタイトル定義
            .navigationBarTitleDisplayMode(.inline)

        }
        .onTapGesture {
            textEditorFocused = false
        }
        .sheet(isPresented: $showDummySheet) {
            DummySheetView(viewModel: viewModel)
        }
    }
    
    private var toolbarContent: some ToolbarContent  {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("DummySheet") {
                    showDummySheet.toggle()
                 }
                NavigationLink("test1", destination: DummyTextView(viewModel: viewModel))
                NavigationLink("test2", destination: DummyTextView(viewModel: viewModel))
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
