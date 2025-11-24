//
//  EditFavoriteView.swift
//  calc
//
//  Created by nyaago on 2025/11/24.
//

import SwiftUI

struct EditFavoriteView: View {
    @State var title: String = ""
    let favoriteExpr: FavoriteExpr
    
    @Environment(\.dismiss) private var dismiss
    
    init(favoriteExpr: FavoriteExpr) {
        self.favoriteExpr = favoriteExpr
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("タイトル")
                .modifier(LabelTextModifier())
            TextField("", text: $title)
                .modifier(SingleLineTextModifier())
            Text("式")
                .modifier(LabelTextModifier())
            Text(favoriteExpr.expr)
                .frame(maxWidth: .infinity,
                       minHeight: 50.0,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .modifier(MultiLineLabelTextModifier())
            Spacer()

        }
        .onAppear() {
            title = self.favoriteExpr.title
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
                self.favoriteExpr.title = self.title
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
    EditFavoriteView(favoriteExpr: FavoriteExpr(expr: "a = 2 * 5", title: "favorite"))
}
