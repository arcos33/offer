//
//  ZillowResultsView.swift
//  Offer
//
//  Created by arkos33 on 12/26/24.
//

import SwiftUI

struct ZillowResultsView: View {
    let searchAddress: String
    let properties: [ZillowProperty]  // NEW: Accept properties directly instead of using ViewModel
    
    var body: some View {
        VStack {
            if properties.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "house.slash")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("No properties found")
                        .font(.headline)
                    Text("No results found for:\n\(searchAddress)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            } else {
                List(properties, id: \.id) { property in
                    PropertyCardView(property: property)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// NEW: Separate view for property cards
struct PropertyCardView: View {
    let property: ZillowProperty
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(property.propertyStatus.displayString)
                .padding(.leading, 16)
                .padding(.top, 8)
                .font(.title2)
                .bold()
            // Property Image
            if let imgSrc = property.imgSrc,
               let url = URL(string: imgSrc) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(16/9, contentMode: .fill)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .aspectRatio(16/9, contentMode: .fill)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .cornerRadius(12)
            }
            
            // Property Details
            VStack(alignment: .leading, spacing: 8) {
                Text(property.streetAddress)
                    .font(.headline)
                
                Text(formatPrice(Double(property.price)))
                    .font(.title2)
                    .bold()
                
                HStack(spacing: 16) {
                    if let beds = property.bedrooms {
                        Label("\(beds) beds", systemImage: "bed.double")
                    }
                    
                    Label(String(format: "%.1f baths", property.bathrooms), systemImage: "shower")
                    
                    Label("\(Int(property.livingArea)) sqft", systemImage: "square")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Text(property.homeType.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    // Helper function to format price
    private func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
}

// Preview provider
struct ZillowResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZillowResultsView(
                searchAddress: "123 Main St",
                properties: [] // Empty array for no results
            )
        }
        
        NavigationView {
            ZillowResultsView(
                searchAddress: "123 Main St",
                properties: [
                    // Add sample Zillow property here for preview with data
                ]
            )
        }
    }
}

