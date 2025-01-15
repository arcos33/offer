//
//  PropertyStatusTests.swift
//  OfferTests
//
//  Created by arkos33 on 1/5/25.
//

import XCTest
@testable import Offer

class PropertyStatusTests: XCTestCase {
    func testOffMarketProperty() throws {
        // GIVEN - Load the JSON file
        let jsonData = try loadJSONFromFile(named: "off_market_property")
        let decoder = JSONDecoder()
        let zillowResponse = try decoder.decode(ZillowResponse.self, from: jsonData)
        
        // WHEN - Determine the property status
        let status = PropertyStatusChecker.determineStatus(
            homeStatus: zillowResponse.homeStatus ?? "",
            datePosted: zillowResponse.datePosted ?? "",
            listingSubType: zillowResponse.listingSubType ?? [:],
            yearBuilt: zillowResponse.yearBuilt,
            priceHistory: zillowResponse.priceHistory,
            daysOnZillow: Int((zillowResponse.timeOnZillow)?.replacingOccurrences(of: " days", with: "") ?? "0"),
            price: zillowResponse.price,
            availabilityDate: nil,
            propertyFacts: ["resoFacts": zillowResponse.resoFacts as Any],
            homeType: zillowResponse.homeType,
            bedrooms: zillowResponse.bedrooms,
            dateSold: zillowResponse.dateSold,
            description: zillowResponse.description,
            brokerageName: zillowResponse.brokerageName,
            zestimate: zillowResponse.zestimate
        )
        
        // Optional: Add debug prints to help diagnose issues
        print("Test Debug:")
        print("homeStatus: \(zillowResponse.homeStatus ?? "")")
        print("datePosted: \(zillowResponse.datePosted ?? "")")
        print("listingSubType: \(zillowResponse.listingSubType ?? [:])")
        print("Determined status: \(status)")
        
        // THEN - Verify the status is off-market
        switch status {
        case .offMarket:
            // Test passes if we get here
            XCTAssertTrue(true)
        default:
            XCTFail("Expected property to be off-market but got \(status)")
        }
    }
}

extension PropertyStatusTests {
    
    private func loadJSONFromFile(named filename: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON file not found"])
        }
        return try Data(contentsOf: url)
    }
}
