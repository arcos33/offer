//
//  PropertiesView.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import SwiftUI

struct PropertiesView: View {
    var body: some View {
        NavigationView {
            List(["123 Main Street, Ogden UT 84043"], id: \.self) { address in
                //NavigationLink(destination: ZillowView(vm: ZillowViewVM(zillowProperty: Zillo)))
                VStack(alignment: .leading) {
                    Text(address)
                        .font(.headline)
                    Text("$1,200,000")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Properties")
        }
    }
}

#Preview {
    PropertiesView()
}
