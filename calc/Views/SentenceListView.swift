//
//  SentencesView.swift
//  calc
//
//  Created by nyaago on 2025/07/15.
//

import SwiftUI

struct SentenceRowView: View {
    var sentenceNode: SentenceNodeWrapper
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(sentenceNode.strtingValue)
                .font(.body)
                .frame(width: 60,
                       alignment: .leading)
            Text(sentenceNode.sentenceText)
                .font(.body)
                .frame(maxWidth: .infinity,
                       minHeight: 12,
                       maxHeight: .infinity,
                       alignment: .topLeading)
        }
        .modifier(ListItemViewModifier())
    }
}

struct SentenceListView: View {
    @Bindable var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(viewModel.identifiableSentenceNodes) { sentenceNode in
                SentenceRowView(sentenceNode: sentenceNode)
                    .modifier(ListViewModifier())
            }
        }
    }
}
