//
//  SentencesView.swift
//  calc
//
//  Created by nyaago on 2025/07/15.
//

import SwiftUI

struct SentenceView: View {
    var identigableSentenceNode: IdentigableSentenceNode
    
    var body: some View {
        Text(identigableSentenceNode.node.sentenceText)
            .font(.body)
            .listRowBackground(Color.textBackColor)
            .listRowSeparatorTint(Color.listRowSeparatorColor)
            .padding(EdgeInsets(top: 5, leading: 0,
                                bottom: 0, trailing: 0))
    }
}

struct SentencesView: View {
    @Binding var viewModel: CalcModel
    
    var identigableSentenceNodes: [IdentigableSentenceNode] {
        get {
            viewModel.sentenceNodes.map { sentenceNode in
                IdentigableSentenceNode(sentenceNode: sentenceNode)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(identigableSentenceNodes) { identigableSentenceNode in
                SentenceView(identigableSentenceNode: identigableSentenceNode)
                    .modifier(ListViewModifier())
            }
        }
    }
}
