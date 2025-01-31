//
//  AddressAutocompleteViewController.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import GooglePlaces
import SwiftUI
import UIKit
import Combine

struct AddressAutocompleteView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var shouldShowResults: Bool
    @Binding var searchAddress: String
    @Binding var zillowResults: [ZillowProperty]
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    
    class Coordinator: NSObject, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate {
        var parent: AddressAutocompleteView
        private var cancellables = Set<AnyCancellable>()
        
        init(_ parent: AddressAutocompleteView) {
            self.parent = parent
        }
        
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            guard let addressString = place.formattedAddress else { return }
            print("Selected address: \(addressString)")
            
            RealEstateService.shared.getZillowIDWith(address: addressString)
                .flatMap { zpids -> AnyPublisher<[ZillowProperty], RealEstateServiceError> in
                    print("Found \(zpids.count) properties, fetching details...")
                    
                    let publishers = zpids.map { zpid in
                        RealEstateService.shared.getPropertyDetails(withZPID: zpid)
                            .mapError { error -> RealEstateServiceError in
                                if let realEstateError = error as? RealEstateServiceError {
                                    return realEstateError
                                }
                                return RealEstateServiceError.networkError(error.localizedDescription)
                            }
                    }
                    
                    guard !publishers.isEmpty else {
                        DispatchQueue.main.async {
                            self.showAlert(
                                in: viewController,
                                message: "We couldn't find this property on Zillow. This might be because the property isn't currently listed or the address format isn't recognized."
                            )
                        }
                        return Just([])
                            .setFailureType(to: RealEstateServiceError.self)
                            .eraseToAnyPublisher()
                    }
                    
                    return Publishers.MergeMany(publishers)
                        .collect()
                        .eraseToAnyPublisher()
                }
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard let self = self else { return }
                        switch completion {
                        case .finished:
                                print("✅ Successfully fetched all property details")
                                self.parent.searchAddress = addressString
                                self.parent.shouldShowResults = true
                                self.parent.presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            self.showAlert(
                                in: viewController,
                                message: """
                                    We couldn't find this property on Zillow. This could be because:
                                    
                                    • The property isn't currently listed
                                    • The address might be too new

                                    Try searching for a different address.
                                    """
                            )
                        }
                    },
                    receiveValue: { [weak self] zillowProperties in
                        print("📦 Received \(zillowProperties.count) Zillow properties")
                        self?.parent.zillowResults = zillowProperties
                    }
                )
                .store(in: &cancellables)
        }
        
        // NEW: Helper method to show UIKit alert
        private func showAlert(in viewController: UIViewController, message: String) {
            let alert = UIAlertController(
                title: "Notice",
                message: message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: ", error.localizedDescription)
            showAlert(
                in: viewController,
                message: "Error finding address: \(error.localizedDescription)\nPlease try again."
            )
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.formattedAddress.rawValue)))
        autocompleteController.placeFields = fields
        let filter = GMSAutocompleteFilter()
        filter.types = ["address"]
        autocompleteController.autocompleteFilter = filter
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {
        // No update needed
    }
}

