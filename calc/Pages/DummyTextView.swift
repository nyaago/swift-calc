//
//  DummyView.swift
//  calc
//
//  Created by nyaago on 2025/01/19.
//

import SwiftUI

struct DummyTextView: View {
    @Environment(\.dismiss) private var dismiss
    var viewModel: CalcModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Dummy")
                    .modifier(LabelTextModifier())
                Text(viewModel.stringValue)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .modifier(MultiLineTextModifier())
                    .frame(maxWidth: .infinity,
                           minHeight: 50,
                           maxHeight: .infinity,
                           alignment: .topLeading)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        dismiss()
                    },
                    label: { Label("Save", systemImage: "arrowshape.down.circle") })
                        
                }
                /*
                 ToolbarItem(placement: .cancellationAction) {
                 Button(action: {
                 dismiss()
                 },
                 label: { Label("Back", systemImage: "arrow.backward")
                 })
                 }
                 */
            }
            //.navigationBarBackButtonHidden(true)
        }
    }
}
