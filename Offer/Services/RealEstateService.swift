//
//  RealEstateService.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import Combine
import Foundation
import UnsplashPhotoPicker
import UIKit

enum RealEstateServiceError: Error {
    case encodingFailed(String)
    case networkError(String)
    case dataUnavailable
    case resourceNotFound
    case decodingFailed(String)
    case serializationFailed(String)
    case noPropertyFound(String)
}

class RealEstateService {
    static let shared = RealEstateService()
    
    let ZWSID = "X1-ZWz16o7tbrvi8b_a6mew"
    let unsplashAccessKey = "-7TduIvOwPEAC3USs4EPZYOoBm7EBb8yFZhfqjfAofs"
    let unsplashSecretKey = "vm6HVz7ACdiWMIF0UoEwfG8AVhwwsTQ_4KQ8fy-thbM"
    private var cancellables = Set<AnyCancellable>()
    
    // New publishers for different data streams
    private let propertyDataSubject = PassthroughSubject<Property, RealEstateServiceError>()
    private let errorSubject = PassthroughSubject<RealEstateServiceError?, Never>()
    
    // New public publishers that other classes can subscribe to
    var propertyDataPublisher: AnyPublisher<Property, RealEstateServiceError> {
        propertyDataSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<RealEstateServiceError?, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    func unsplashConfiguration() -> UnsplashPhotoPickerConfiguration {
        return UnsplashPhotoPickerConfiguration(accessKey: unsplashAccessKey, secretKey: unsplashSecretKey, allowsMultipleSelection: false)
    }
    
    func getPropertyData(address: String) -> AnyPublisher<Property, RealEstateServiceError> {
        guard let encodedString = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Fail(error: RealEstateServiceError.encodingFailed("Failed to encode the address"))
                .eraseToAnyPublisher()
        }
        
        let headers = [
            "x-rapidapi-host": "realty-mole-property-api.p.rapidapi.com",
            "x-rapidapi-key": "9652b9feb3msh1a6581042834538p1dd939jsn3185123922f9"
        ]
        
        guard let url = URL(string: "https://realty-mole-property-api.p.rapidapi.com/properties?address=\(encodedString)") else {
            return Fail(error: RealEstateServiceError.networkError("Invalid URL"))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RealEstateServiceError.networkError("Invalid response")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 404:
                    throw RealEstateServiceError.resourceNotFound
                default:
                    throw RealEstateServiceError.networkError("Status code: \(httpResponse.statusCode)")
                }
            }
            .decode(type: [Property].self, decoder: JSONDecoder())
            .tryMap { properties -> Property in
                guard let property = properties.first else {
                    throw RealEstateServiceError.noPropertyFound("No property found")
                }
                return property
            }
            .mapError { error -> RealEstateServiceError in
                if let realEstateError = error as? RealEstateServiceError {
                    return realEstateError
                }
                if error is DecodingError {
                    return RealEstateServiceError.decodingFailed(error.localizedDescription)
                }
                return RealEstateServiceError.networkError(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getPropertyDetails(withZPID zpid: Int) -> AnyPublisher<Zillow, Error> {
        let headers = [
            "x-rapidapi-host": "zillow-com1.p.rapidapi.com",
            "x-rapidapi-key": "9652b9feb3msh1a6581042834538p1dd939jsn3185123922f9"
        ]
        
        guard let url = URL(string: "https://zillow-com1.p.rapidapi.com/property?zpid=\(zpid)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                // Print raw JSON string
                if let jsonString = String(data: result.data, encoding: .utf8) {
                    print("Raw JSON Response:")
                    print(jsonString)
                    print("DONE PRINTING")
                    
                }
                return result.data
            }
            .decode(type: ZillowResponse.self, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type) in context \(context)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type \(type) in context \(context)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found in context \(context)")
                    case .dataCorrupted(let context):
                        print("Data corrupted in context \(context)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
                return error
            }
            .tryMap { response -> Zillow in
                let status = PropertyStatusChecker.determineStatus(
                    homeStatus: response.homeStatus ?? "",
                    datePosted: response.datePosted ?? "",
                    listingSubType: response.listingSubType ?? [:],
                    yearBuilt: response.yearBuilt,
                    priceHistory: response.priceHistory,  // Directly use PriceHistoryItem
                    daysOnZillow: Int((response.timeOnZillow)?.replacingOccurrences(of: " days", with: "") ?? "0"),
                    price: response.price,
                    availabilityDate: nil,
                    propertyFacts: ["resoFacts": response.resoFacts as Any],
                    homeType: response.homeType,
                    bedrooms: response.bedrooms,
                    dateSold: response.dateSold,
                    description: response.description,
                    brokerageName: response.brokerageName,
                    zestimate: response.zestimate
                )
                
                return Zillow(
                    id: UUID(),
                    zpid: response.zpid,
                    homeStatus: response.homeStatus ?? "",
                    mlsid: response.mlsid,
                    price: Double(response.price ?? 0),
                    bedrooms: response.bedrooms,
                    bathrooms: response.bathrooms ?? 0,
                    livingArea: response.livingArea ?? 0,
                    homeType: response.homeType ?? "",
                    timeOnZillow: response.timeOnZillow,
                    yearBuilt: response.yearBuilt,
                    lotSize: Double(response.livingArea ?? 0),
                    imgSrc: response.imgSrc,
                    streetAddress: response.streetAddress ?? "",
                    city: response.city ?? "",
                    state: response.state ?? "",
                    zipcode: response.zipcode ?? "",
                    url: response.url ?? "",
                    description: response.description,
                    architecturalStyle: response.resoFacts?.architecturalStyle,
                    propertyStatus: status
                )
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getZillowIDWith(address: String) -> AnyPublisher<[Int], RealEstateServiceError> {
        guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return Fail(error: RealEstateServiceError.encodingFailed("Failed to encode the address"))
                .eraseToAnyPublisher()
        }
        
        let headers = [
            "x-rapidapi-host": "zillow-com1.p.rapidapi.com",
            "x-rapidapi-key": "9652b9feb3msh1a6581042834538p1dd939jsn3185123922f9"
        ]
        
        guard let url = URL(string: "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch?location=\(encodedAddress)") else {
            return Fail(error: RealEstateServiceError.networkError("Invalid URL"))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RealEstateServiceError.networkError("Invalid response")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    // Save response to file for debugging
                    let fm = FilesManager()
                    try fm.save(fileNamed: "zillowResponse.json", data: data)
                    return data
                case 404:
                    throw RealEstateServiceError.resourceNotFound
                default:
                    throw RealEstateServiceError.networkError("Status code: \(httpResponse.statusCode)")
                }
            }
            .tryMap { data -> [Int] in
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                // Handle array response
                if let jsonArray = jsonObject as? [[String: Any]] {
                    return jsonArray.compactMap { json -> Int? in
                        return json["zpid"] as? Int
                    }
                }
                // Handle single object response
                else if let jsonDict = jsonObject as? [String: Any],
                        let zpid = jsonDict["zpid"] as? Int {
                    return [zpid]
                }
                // Handle empty or invalid response
                else {
                    print("No valid ZPIDs found in response")
                    return []
                }
            }
            .mapError { error -> RealEstateServiceError in
                if let realEstateError = error as? RealEstateServiceError {
                    return realEstateError
                }
                return RealEstateServiceError.serializationFailed(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func getZillowPropertyImages(WithID zpid: String) {
        guard let encodedZPID = zpid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let headers = [
            "x-rapidapi-host": "zillow-com1.p.rapidapi.com",
            "x-rapidapi-key": "9652b9feb3msh1a6581042834538p1dd939jsn3185123922f9"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://zillow-com1.p.rapidapi.com/images?zpid=\(encodedZPID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
            } else {
                if let response = response as? HTTPURLResponse {
                    print(response)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func downloadImage(withURL url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
