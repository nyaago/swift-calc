//
//  ContentView.swift
//  calc
//
//  Created by nyaago.
//

import SwiftUI

struct MainView: View {
    
    enum InputViewType: Int {
        case full = 1
        case bySentence =  2
    }

    @State var editText = ""
    var viewModel = CalcModel()
    @State var showDummySheet: Bool = false
    @FocusState var textEditorFocused: Bool
    @State var inputViewType: InputViewType = .full
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        // 入力
        AnyView(buildInputView())
            //.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.padding(.horizontal, 10.0)
            /*
            .toolbar {
                toolbarContent
            }
             */
            //.background(Color.black)
            /*
            .navigationTitle("Home")            // ナビゲーションタイトル定義
            .navigationBarTitleDisplayMode(.inline)
             */

        /*
        .onTapGesture {
            textEditorFocused = false
        }
        */
        /*
        .sheet(isPresented: $showDummySheet) {
            DummySheetView(viewModel: viewModel)
        }
         */
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
    
    private func buildInputView() -> any View {
        switch(self.inputViewType) {
        case .full:
            return FullExprInputView(viewModel: viewModel, textEditorFocused: $textEditorFocused)
        case .bySentence:
            return SentencesInputView(viewModel: viewModel)
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
