//
//  ExprInputView.swift
//  calc
//
//  Created by nyaago on 2024/12/17.
//

import SwiftUI

struct ExprInputView: View {
    @State var editText = ""
    @Binding var viewModel: CalcModel
    @FocusState.Binding var textEditorFocused: Bool

    enum InputViewType: Int {
        case full = 1
        case bySentence =  2
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("式を入力")
                .modifier(LabelTextModifier())
            AnyView(buildInputView())
        }
    }
    
    private func buildInputView() -> any View {
        FullExprInputView(editText: editText, viewModel: $viewModel, textEditorFocused: $textEditorFocused)
    }
}

 #Preview {
     @Previewable @State var calcModel: CalcModel = CalcModel()
     @FocusState var focused: Bool
     ExprInputView(viewModel: $calcModel,
                   textEditorFocused: $focused)
         .preferredColorScheme(.dark)
 }
