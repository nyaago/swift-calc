//
//  Untitled.swift
//  calc
//
//  Created by nyaago on 2025/07/31.
//

import SwiftUI


struct FullExprInputView: View {
    @State var editText = ""
    @Bindable var viewModel: CalcModel
    @FocusState.Binding var textEditorFocused: Bool
    @Binding var inputViewType: MainView.InputViewType

    init(viewModel: CalcModel, textEditorFocused:  FocusState<Bool>.Binding, inputViewType: Binding<MainView.InputViewType>) {
        self.viewModel = viewModel
        self._inputViewType = inputViewType
        self._textEditorFocused = textEditorFocused
        if let newExpr = viewModel.expr {
            self.editText = newExpr
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack{
                // 計算結果
                ResultView(viewModel: self.viewModel)
                
                HStack(alignment: .center) {
                    Text("式を入力")
                        .modifier(LabelTextModifier())
                    Spacer()
                }
                TextEditor(text: $editText)
                    .focused(self.$textEditorFocused)
                    .keyboardType(.numbersAndPunctuation)
                    .scrollContentBackground(Visibility.hidden)
                    .modifier(MultiLineTextModifier())
                    .frame(maxWidth: .infinity,
                           minHeight: 50.0,
                           maxHeight: .infinity,
                           alignment: .topLeading)
                    .onAppear() {
                        // UIApplication.shared.closeKeyboard()
                        self.editText = self.viewModel.expr ?? ""
                    }.onChange(of: self.editText) { oldText, newText in
                        viewModel.expr = newText
                        viewModel.calc()
                    }
                // 解析結果
                DetailResultView(viewModel: self.viewModel)
            }
            .navigationTitle("計算機")            // ナビゲーションタイトル定義
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            //
        }
        .onTapGesture {
            self.textEditorFocused = false
        }
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

    private func buildExprVariables() -> [ExprVariable] {
        guard let symbolTable = viewModel.symbolTable else {
            return []
        }
        return symbolTable.asArray.map { symbolElement in
            ExprVariable(name: symbolElement.name, value: symbolElement.value)
        }
    }
    
}

 #Preview {
     @Previewable @State var viewModel: CalcModel = CalcModel(expr: "a = 5 * 6 \nb = a + 5")
     @Previewable @State var inputViewType: MainView.InputViewType = .full
     @FocusState var focused: Bool
     
     FullExprInputView(viewModel: viewModel,
                       textEditorFocused: $focused, inputViewType: $inputViewType)
         .preferredColorScheme(.dark)
 }
