//
//  AcknowledgementsView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI

struct AcknowledgementsView: View {
    @StateObject private var viewModel = AcknowledgementsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.rowTypes, id: \.self) { row in
                switch row {
                case .sectionHeader(let title):
                    Text(title)
                        .font(.headline)
                        .padding(.vertical, 8)
                case .stockTableViewCell(let text):
                    Text(text)
                }
            }
        }
        .draggableDebugViewName("AcknowledgementsView")
        .navigationTitle("Acknowledgements")
    }
}

#Preview {
    AcknowledgementsView()
}
