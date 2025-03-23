//
//  DummySheet.swift
//  calc
//
//  Created by nyaago on 2025/03/11.
//
import SwiftUI

struct DummySheetView: View {
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", action: {
                        dismiss()
                    })
                }
            }
        }
    }
}

