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
    @Bindable private var viewModel: CalcModel
    
    init(senteneNode: IdentifiableSentenceNode, viewModel: CalcModel, sentenceText: String = "") {
        self.senteneNode = senteneNode
        self.viewModel = viewModel
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
    @Bindable private var viewModel: CalcModel
    @State var editMode: EditMode = .inactive
    @Binding var inputViewType: MainView.InputViewType
    
    @State private var path: NavigationPath = NavigationPath()

//    private var sentenceTexts: [Binding<String>] = []
    
    /*
    init(viewModel: CalcModel, _sentenceTexts: [String]) {
        self.viewModel = viewModel
        self._sentenceTexts = _sentenceTexts
    }
     */
    init(viewModel: CalcModel, inputViewType: Binding<MainView.InputViewType>) {
        self.viewModel = viewModel
        self._inputViewType = inputViewType
        //        self.sentenceTexts = viewModel.identifiableSentenceNodes.map { e in e.sentenceText }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                List {
                    ForEach(viewModel.identifiableSentenceNodes, id: \.self) { identifiableSentenceNode in
                        NavigationLink(destination:
                                        EditSentenceView(sentenceNode: identifiableSentenceNode, viewModel: viewModel)) {
                            SentenceInputView(senteneNode: identifiableSentenceNode, viewModel: viewModel)
                        }
                    }
                    .onMove { indexSet, newIndex in
                    }
                    .onDelete(perform:  { indexSet in
                        
                        
                    })
                    .onAppear() {
                        
                    }
                }
                .environment(\.editMode, $editMode)
                .navigationTitle("計算機")            // ナビゲーションタイトル定義
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarContent
                    editToolbarContent
                    addToolbarContent
                }
            }
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
    
    private var editToolbarContent: some ToolbarContent {
        let text: String = editMode == EditMode.inactive ? "Edit" : "Done"
        return ToolbarItem(placement: .navigation) {
            Button(text, action: {
                if editMode == .inactive {
                    editMode = .active
                }
                else {
                    editMode = .inactive
                }
                    
            })
        }
    }
    
    private var addToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button("Add", systemImage: "plus", action: {
                print("Add")
            })
            .disabled(editMode == .active)
        }
    }
}
