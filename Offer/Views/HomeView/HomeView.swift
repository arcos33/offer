//
//  HomeView.swift
//  OfferNow
//
//  Created by arkos33 on 8/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var recentSearches = ["123 Main St", "456 Oak St"]
    @State private var featuredProperties = [
        Property(addressLine1: "123 Main Street", city: "Ogden", state: "UT", zipCode: "84045", county: "UT", bedrooms: 3, bathrooms: 2, lotSize: 2500, yearBuilt: 1997, propertyType: "House", taxAssessment: [:], id: "1", longitude: 132.23, latitude: 43.23)
    ]
    @State private var showingAutocomplete = false
    @State private var searchAddress = ""
    @State private var shouldNavigate = false
    @State private var zillowResults: [Zillow] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Button(action: {
                        showingAutocomplete = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search by address")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding()

                    Text("Recent Searches")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(recentSearches, id: \.self) { search in
                        Text(search)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }

                    Divider()
                        .padding(.horizontal)
 
                    Text("Featured Properties")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(featuredProperties, id: \.id) { property in
                        NavigationLink(value: property) {
                            FeaturedPropertyRow(property: property)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Home")
            .navigationDestination(for: Property.self) { property in
                PropertyDetailView(property: property)
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                ZillowResultsView(
                    searchAddress: searchAddress,
                    properties: zillowResults
                )
            }
        }
        .sheet(isPresented: $showingAutocomplete) {
            AddressAutocompleteView(
                shouldShowResults: $shouldNavigate,
                searchAddress: $searchAddress,
                zillowResults: $zillowResults,
                showAlert: $showAlert,
                alertMessage: $alertMessage
            )
        }
        .alert("Notice", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onChange(of: zillowResults) { oldResults, newResults in
            print("HomeView received \(newResults.count) Zillow properties")
        }
        .onChange(of: shouldNavigate) { oldValue, newValue in
            print("Navigation triggered: \(newValue), have \(zillowResults.count) properties")
            if newValue {
                if !searchAddress.isEmpty && !recentSearches.contains(searchAddress) {
                    recentSearches.insert(searchAddress, at: 0)
                    if recentSearches.count > 5 {
                        recentSearches.removeLast()
                    }
                }
            }
        }
    }
}

struct FeaturedPropertyRow: View {
    let property: Property

    var body: some View {
        HStack {
            Image(systemName: "sun.min")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(property.addressLine1)
                    .font(.headline)
                Text("234,000")
                    .font(.subheadline)
                HStack {
                    Text("\(property.bedrooms) Beds")
                    Text("\(property.bathrooms) Baths")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HomeView()
}

