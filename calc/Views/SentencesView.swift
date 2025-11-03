//
//  SentencesView.swift
//  calc
//
//  Created by nyaago on 2025/07/15.
//

import SwiftUI

struct SentenceView: View {
    var identifiableSentenceNode: SentenceNodeWrapper
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(identifiableSentenceNode.strtingValue)
                .font(.body)
                .frame(width: 60,
                       alignment: .leading)
            Text(identifiableSentenceNode.sentenceText)
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
    @Bindable var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List(viewModel.identifiableSentenceNodes) { identifiableSentenceNode in
                SentenceView(identifiableSentenceNode: identifiableSentenceNode)
                    .modifier(ListViewModifier())
            }
        }
    }
}
