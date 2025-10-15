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
    @State var showDummySheet: Bool = false


    /*
    init(viewModel: Binding<CalcModel>, textEditorFocused: FocusState<Bool>.Binding) {
        self._viewModel = viewModel
        self._textEditorFocused = textEditorFocused
    }
     */

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
            // dummy の sheet 表示
            .sheet(isPresented: $showDummySheet) {
                DummySheetView(viewModel: viewModel)
            }
            //
            .toolbar {
                toolbarContent
            }

        }
        .onTapGesture {
            self.textEditorFocused = false
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
    
    // dummy の toolbar content
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

 #Preview {
     @Previewable @State var calcModel: CalcModel = CalcModel()
     @FocusState var focused: Bool
     FullExprInputView(viewModel: calcModel,
                   textEditorFocused: $focused)
         .preferredColorScheme(.dark)
 }
