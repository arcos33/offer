//
//  PropertyDetailView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI

struct PropertyDetailView: View {
    let property: Property

    var body: some View {
        Text("Details for \(property.addressLine1)")
    }
}
