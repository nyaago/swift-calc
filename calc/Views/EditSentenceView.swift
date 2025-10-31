//
//  EditSentenceView.swift
//  calc
//
//  Created by nyaago on 2025/10/20.
//

import SwiftUI

struct EditSentenceView: View {
    var senteneNode: IdentifiableSentenceNode
    @Bindable private var viewModel: CalcModel
    @State var text: String

    @Environment(\.dismiss) private var dismiss
    
    init(sentenceNode: IdentifiableSentenceNode,  viewModel: CalcModel) {
        self.senteneNode = sentenceNode
        self.text = sentenceNode.sentenceText
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
                guard let  index = viewModel.sentenceNodes.firstIndex(where: { node in
                    node == senteneNode.node
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

/*
 #Preview {
 @State @Previewable var sentenceNode: IdentifiableSentenceNode = IdentifiableSentenceNode(sentenceNode: SentenceNode())
 EditSentenceView(senteneNode: $sentenceNode)
 }
 */
