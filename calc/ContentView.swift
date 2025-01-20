//
//  ContentView.swift
//  calc
//
//  Created by nyaago.
//

import SwiftUI

struct ContentView: View {
    enum DetailedViewType: Int {
        case polishNotation = 1
        case list2 =  2
        case list3 = 3
    }
    
    @State var editText = ""
    @State var detailedViewType: DetailedViewType = .polishNotation
    var viewModel = CalcModel()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10.0) {
                // 計算結果
                ResultView(viewModel: self.viewModel)
                // 入力
                ExprInputView(viewModel: self.viewModel)
                // 解析結果
                deitaledResultView
            }
            .padding(.horizontal, 10.0)
            .padding(.bottom, 20.0)
            .toolbar {
                itemGroup
            }.background(Color.black)
        }
    }
    
    private var itemGroup: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Button(action: {
                self.detailedViewType = .polishNotation
            }) {
                Image(systemName: "doc.text")
            }
            Spacer()
            Button(action: {
                self.detailedViewType = .list2
            }) {
                Image(systemName: "list.bullet.rectangle")
            }
            Spacer()
            Button(action: {
                self.detailedViewType = .list3
            }) {
                Image(systemName: "info")
            }
            Spacer()
        }
    }
    
    private var deitaledResultView: some View {
        return AnyView( buildDeitaledResultView() )
    }

    private func buildDeitaledResultView() -> any View {
        switch ( self.detailedViewType ) {
        case .polishNotation:
            return PolishNotationView(viewModel: self.viewModel)
        case .list2:
            return DummyTextView(viewModel: self.viewModel)
        case .list3:
            return DummyTextView(viewModel: self.viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

extension UIApplication {
    func closeKeyboard() {
        // sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
