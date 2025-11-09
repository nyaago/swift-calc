//
//  EditSentenceView.swift
//  calc
//
//  Created by nyaago on 2025/10/20.
//

import SwiftUI

struct EditSentenceView: View {
    var senteneNode: SentenceNodeWrapper?
    @Bindable private var viewModel: CalcModel
    @State var text: String

    @Environment(\.dismiss) private var dismiss
    
    init(sentenceNode: SentenceNodeWrapper,  viewModel: CalcModel) {
        self.senteneNode = sentenceNode
        self.text = sentenceNode.sentenceText
        self.viewModel = viewModel
    }
    
    // preview 用
    init(text: String, viewModel: CalcModel) {
        self.text = text
        self.viewModel = viewModel
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
        .navigationTitle("変更")            // ナビゲーションタイトル定義
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var doneToolbarContent: some ToolbarContent {
        let labelText: String = "Done"
        return ToolbarItem(placement: .primaryAction) {
            Button(labelText, action: {
                guard let senteneNode = self.senteneNode else {
                    return
                }
                guard let  index = viewModel.sentenceNodesWrapper.firstIndex(where: { nodeWrapper in
                    nodeWrapper.node == senteneNode.node
                })
                else {
                    dismiss()
                    return
                    
                }
                do {
                    try viewModel.replaceSentenceBySentence(index: index, sentence: text)
                }
                catch {
                    print("failed to replace sentence")
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
     EditSentenceView(text: "a = 5 * 6 \n", viewModel: viewModel)
 }
