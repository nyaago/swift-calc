//
//  ExprInputView.swift
//  calc
//
//  Created by nyaago on 2024/12/17.
//

import SwiftUI

struct ExprInputView: View {
    @State var editText = ""
    @Bindable var viewModel: CalcModel
    @FocusState.Binding var textEditorFocused: Bool

    enum InputViewType: Int {
        case full = 1
        case bySentence =  2
    }

    @State var inputViewType: InputViewType = .full
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Text("式を入力")
                    .modifier(LabelTextModifier())
                Spacer()
            }.overlay(alignment: .bottomTrailing)  {
                viewTypeMenu
                    .frame(maxHeight: .infinity,
                           alignment: .bottomTrailing)
                    .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                        bottom: 5.0, trailing: 10.0))
            }
            AnyView(buildInputView())
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
    
    private var viewTypeMenu: some View {
        return Menu {
            Button("Full Text", systemImage: "doc.text", action: {
                self.inputViewType = .full
            })
            .disabled(inputViewType == .full)
            Button("By Sentence", systemImage: "list.bullet.rectangle", action: {
                self.inputViewType = .bySentence
            })
            .disabled(inputViewType == .bySentence)
        }
        label: { Label("Change", systemImage: "list.bullet")
        }
    }

}

 #Preview {
     @Previewable @State var calcModel: CalcModel = CalcModel()
     @FocusState var focused: Bool
     ExprInputView(viewModel: calcModel,
                   textEditorFocused: $focused)
         .preferredColorScheme(.dark)
 }
