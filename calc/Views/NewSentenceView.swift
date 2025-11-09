//
//  NewSentenceView.swift
//  calc
//
//  Created by nyaago on 2025/10/25.
//

import SwiftUI

struct NewSentenceView: View {
    
    @Bindable private var viewModel: CalcModel
    @State var text: String

    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CalcModel) {
        self.viewModel = viewModel
        self.text = ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("式を編集")
                .modifier(LabelTextModifier())
            TextField("", text: $text)
                .modifier(SingleLineTextModifier())
            Spacer()
        }
        .toolbar(content:  {
            doneToolbarContent
            cancelToolbarContent
        })
        .navigationTitle("行を作成")            // ナビゲーションタイトル定義
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var doneToolbarContent: some ToolbarContent {
        let labelText: String = "Done"
        return ToolbarItem(placement: .primaryAction) {
            Button(labelText, action: {
                do {
                    try viewModel.appendSentence(sentence: self.text)
                }
                catch {
                    print("failed to append sentence")
                }
                dismiss()
            })
        }
    }

    private var cancelToolbarContent: some ToolbarContent {
        let text: String = "Cancel"
        return ToolbarItem(placement: .navigation) {
            Button(text, action: {
                dismiss()
            })
        }
    }
}

#Preview {
    @Previewable @State var viewModel: CalcModel = CalcModel(expr: "a = 5 * 6 \nb = a + 5")
    NewSentenceView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
