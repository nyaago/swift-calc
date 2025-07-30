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
        HStack(alignment: .center, spacing: 0) {
            Text(identigableSentenceNode.strtingValue)
                .font(.body)
                .frame(width: 60,
                       alignment: .leading)
            Text(identigableSentenceNode.node.sentenceText)
                .font(.body)
                .frame(maxWidth: .infinity,
                       minHeight: 12,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
        .modifier(ListItemViewModifier())
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
