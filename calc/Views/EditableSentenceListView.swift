//
//  SentenceInputView.swift
//  calc
//
//  Created by nyaago on 2025/08/05.
//

import SwiftUI

struct EditableSentenceRowView: View {
    var senteneNode: SentenceNodeWrapper
    @State var sentenceText = ""
    @Bindable private var viewModel: CalcModel
    
    init(senteneNode: SentenceNodeWrapper, viewModel: CalcModel, sentenceText: String = "") {
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
            }
    }
}

struct EditableSentencesListView: View {
    @Bindable private var viewModel: CalcModel
    @State var editMode: EditMode = .inactive
    @Binding var inputViewType: MainView.InputViewType
    
    @State private var path: NavigationPath = NavigationPath()

    init(viewModel: CalcModel, inputViewType: Binding<MainView.InputViewType>) {
        self.viewModel = viewModel
        self._inputViewType = inputViewType
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                // 計算結果
                ResultView(viewModel: self.viewModel)

                List {
                    ForEach(viewModel.sentenceNodesWrapper, id: \.self) { identifiableSentenceNode in
                        NavigationLink(destination:
                                        EditSentenceView(sentenceNode: identifiableSentenceNode, viewModel: viewModel)) {
                            EditableSentenceRowView(senteneNode: identifiableSentenceNode, viewModel: viewModel)
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
            NavigationLink(destination: NewSentenceView(viewModel: self.viewModel)) {
                Text("Add")
            }
            .disabled(editMode == .active)
        }
    }
}
