//
//  AcknowledgementsViewModel.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI

class AcknowledgementsViewModel: ObservableObject {
    enum RowType: Hashable {
        case sectionHeader(String)
        case stockTableViewCell(String)
    }
    
    @Published var rowTypes: [RowType] = []
    
    init() {
        setupRows()
    }
    
    private func setupRows() {
        var rows: [RowType] = []
        rows.append(.stockTableViewCell("www.icons8.com"))
        rows.append(.stockTableViewCell("www.ramotion.com/"))
        self.rowTypes = rows
    }
}
