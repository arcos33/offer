//
//  PropertySearchView.swift
//  Offer
//
//  Created by arkos33 on 12/26/24.
//

import SwiftUI

enum NavigationPath {
    case results(address: String)
}

struct PropertySearchView: View {
    @State private var showingAutocomplete = false
    @State private var searchAddress = ""
    @State private var shouldNavigate = false
    @State private var isLoading = false
    @State private var zillowResults: [ZillowProperty] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Searching for property...")
                            .foregroundColor(.secondary)
                    }
                } else {
                    // Search Button
                    Button(action: {
                        showingAutocomplete = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                            Text("Search Address")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Instructions or placeholder content
                    VStack(spacing: 16) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("Enter an address to search for properties")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Property Search")
            .navigationDestination(isPresented: $shouldNavigate) {
                ZillowResultsView(
                    searchAddress: searchAddress,
                    properties: zillowResults
                )
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
                print("PropertySearchView received \(newResults.count) Zillow properties")
                isLoading = false
            }
            .onChange(of: shouldNavigate) { oldValue, newValue in
                print("Navigation triggered: \(newValue), have \(zillowResults.count) properties")
            }
            .onChange(of: showingAutocomplete) { oldValue, isShowing in
                if isShowing {
                    isLoading = true
                }
            }
        }
        .draggableDebugViewName("PropertySearchView")
    }
}

// MARK: - Preview
#Preview {
    PropertySearchView()
}

