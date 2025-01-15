//
//  TestProperties.swift
//  OfferTests
//
//  Created by arkos33 on 1/5/25.
//

enum TestProperties {
    // Off-market properties
    static let offMarketProperties = [
        "2149 5th Ave W, Seattle, WA 98119 - good example of empty priceHistory",
        "283 W Autumn Creek Dr, Saratoga Springs, UT 84045 - Off-market with specific resoFacts structure"
        // Add more addresses...
    ]
    
    // For sale properties
    static let forSaleProperties = [
        "2964 S Willow Creek Dr, Saratoga Springs, UT 84045",
        // Add more addresses...
    ]
    
    static let forSaleWithDaysInMarket = [
        "2964 S Willow Creek Dr, Saratoga Springs, UT 84045"
    ]
    
    // Pending properties
    static let pendingProperties = [
        "",
        // Add more addresses...
    ]
    
    // Sold properties
    static let soldProperties = [
        "",
        // Add more addresses...
    ]
    
    static let noValidZPIDFound = [
        "456 Park Ave, Seattle, WA 98102"
    ]
}
