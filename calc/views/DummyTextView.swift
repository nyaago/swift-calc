//
//  DummyView.swift
//  calc
//
//  Created by nyaago on 2025/01/19.
//

import SwiftUI

struct DummyTextView: View {
    var viewModel: CalcModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Dummy")
                .font(.headline)
                .padding(EdgeInsets(top: 10.0, leading: 10.0,
                                    bottom: 5.0, trailing: 10.0))
                .foregroundColor(Color.labelTextColor)
                .background(Color.labelBackColor)
            Text(viewModel.stringValue)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .font(.title)
                .border(Color.labelBackColor)
                .padding(EdgeInsets(top: 0, leading: 0,
                                    bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity,
                       minHeight: 50,
                       maxHeight: .infinity,
                       alignment: .topLeading)
                .foregroundColor(Color.textColor)
                .background(Color.textBackColor)
                .offset(x: 0.0, y: -0)        }

    }
}
