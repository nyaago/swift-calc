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
    }
    
    private var toolbarContent: some ToolbarContent  {
        ToolbarItem(placement: .primaryAction) {
            Menu {
                Button("Full Text", systemImage: "doc.text", action: {
                    self.inputViewType = .full
                })
                .disabled(inputViewType == .full)
                Button("By Sentence", systemImage: "list.bullet.rectangle", action: {
                    self.inputViewType = .bySentence
                })
                .disabled(inputViewType == .bySentence)
            }
            label: {
                Label("", systemImage: "list.bullet")
            }
        }
    }
    
    
    
    private func buildInputView() -> any View {
        switch(self.inputViewType) {
        case .full:
            return FullExprInputView(viewModel: viewModel,
                                     textEditorFocused: $textEditorFocused,
                                     inputViewType: self.$inputViewType)
        case .bySentence:
            return SentencesInputView(viewModel: viewModel,
                                      inputViewType: self.$inputViewType)
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
