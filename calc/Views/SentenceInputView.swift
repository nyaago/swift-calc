//
//  SentenceInputView.swift
//  calc
//
//  Created by nyaago on 2025/08/05.
//

import SwiftUI

struct SentenceInputView: View {
    var senteneNode: IdentifiableSentenceNode
    @State var sentenceText = ""
    @Binding private var viewModel: CalcModel
    
    init(senteneNode: IdentifiableSentenceNode, viewModel: Binding<CalcModel>, sentenceText: String = "") {
        self.senteneNode = senteneNode
        self._viewModel = viewModel
    }
    
    var body: some View {
        Text(self.sentenceText)
            .font(.body)
            .listRowBackground(Color.textBackColor)
            .listRowSeparatorTint(Color.listRowSeparatorColor)
            .padding(EdgeInsets(top: 5, leading: 0,
                                bottom: 0, trailing: 0))
            .onAppear() {
                self.sentenceText = senteneNode.sentenceText
            }
            .onSubmit {
                print("submit \(self.sentenceText)")
               // senteneNode.sentenceText = self.sentenceText
               // viewModel.sentenceNodes[0]
                
            }
    }
}

struct SentencesInputView: View {
    @Binding private var viewModel: CalcModel
    @State var editMode: EditMode = .transient
//    private var sentenceTexts: [Binding<String>] = []
    
    /*
    init(viewModel: CalcModel, _sentenceTexts: [String]) {
        self.viewModel = viewModel
        self._sentenceTexts = _sentenceTexts
    }
     */
    
    init(viewModel: Binding<CalcModel>) {
       self._viewModel = viewModel
        //        self.sentenceTexts = viewModel.identifiableSentenceNodes.map { e in e.sentenceText }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                ForEach(viewModel.identifiableSentenceNodes, id: \.self) { identifiableSentenceNode in
                    SentenceInputView(senteneNode: identifiableSentenceNode, viewModel: $viewModel)
                }
                .onMove { indexSet, newIndex in
                }
                .onDelete(perform:  { indexSet in
                    
                })
                .onAppear() {
                
                }
            }
            .environment(\.editMode, $editMode)
        }
    }

}
