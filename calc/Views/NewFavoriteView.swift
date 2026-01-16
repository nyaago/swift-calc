//
//  NewFavoriteView.swift
//  calc
//
//  Created by nyaago on 2025/11/17.
//

import SwiftUI

struct NewFavoriteView: View {
    
    @State var title: String = ""
    let expr: String
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    init(expr: String) {
        self.expr = expr
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("タイトル")
                .modifier(LabelTextModifier())
            TextField("", text: $title)
                .modifier(SingleLineTextModifier())
            Text("式")
                .modifier(LabelTextModifier())
            Text(expr)
                .frame(maxWidth: .infinity,
                       minHeight: 50.0,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .modifier(MultiLineLabelTextModifier())
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
                let favoriteExpr = FavoriteExpr(expr: expr, title: title)
                modelContext.insert(favoriteExpr)
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
    NewFavoriteView(expr: "a = 5 * 7")
}
