//
//  ZillowResultsViewModel.swift
//  Offer
//
//  Created by arkos33 on 12/26/24.
//

import Combine

class ZillowResultsViewModel: ObservableObject {
    @Published var properties: [ZillowProperty] = []
    @Published var error: RealEstateServiceError?
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    func searchProperties(address: String) {
        isLoading = true
        
        RealEstateService.shared.getZillowIDWith(address: address)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            }, receiveValue: { searchResults in
                print("Found \(searchResults.count) properties")
            })
            .store(in: &cancellables)
    }
}
