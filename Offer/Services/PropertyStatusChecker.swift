//
//  PropertyStatusChecker.swift
//  Offer
//
//  Created by arkos33 on 12/27/24.
//

import Foundation

struct PropertyStatusChecker {
    static func determineStatus(homeStatus: String,
                              datePosted: String,
                              listingSubType: [String: Bool],
                              yearBuilt: Int? = nil,
                              priceHistory: [PriceHistoryItem]?,
                              daysOnZillow: Int? = nil,
                              price: Int? = nil,
                              availabilityDate: Int? = nil,
                              propertyFacts: [String: Any]? = nil,
                              homeType: String? = nil,
                              bedrooms: Int?,
                              dateSold: String? = nil,
                              description: String?,
                              brokerageName: String?,
                              zestimate: Int?) -> PropertyStatus {
        
        print("Debug - Status Check:")
        print("homeStatus: \(homeStatus)")
        print("datePosted: '\(datePosted)'")
        print("listingSubType: \(listingSubType)")
        
        // Check off-market condition first
        let isOtherStatus = homeStatus == "OTHER"
        let isEmptyDatePosted = datePosted.isEmpty || datePosted == ""
        let allSubTypesFalse = listingSubType.values.allSatisfy { $0 == false }
        
        print("Off-market conditions:")
        print("- Is OTHER status: \(isOtherStatus)")
        print("- Is empty datePosted: \(isEmptyDatePosted)")
        print("- All subtypes false: \(allSubTypesFalse)")
        
        if isOtherStatus && isEmptyDatePosted && allSubTypesFalse {
            print("✓ Setting status to off-market")
            return .offMarket
        }
        
        // Check if the most recent price history event indicates the property is off market
        if let mostRecentEvent = priceHistory?.first?.event?.lowercased() {
            print("Most recent event: \(mostRecentEvent)")
            if mostRecentEvent.contains("listing removed") ||
               mostRecentEvent.contains("delisted") {
                return .offMarket
            }
        }
        
        // Updated off-market check
        if homeStatus == "OTHER" &&
           listingSubType.values.allSatisfy({ $0 == false }) &&
           !(priceHistory?.isEmpty ?? true) {
            return .offMarket
        }
        
        
        if homeStatus == "PRE_FORECLOSURE" {
            return .preForeclosure(estimatedValue: zestimate)
        }
        
        if homeStatus == "FORECLOSED" {
            let isBankOwned = listingSubType["is_bankOwned"] == true
            return .foreclosed(isBankOwned: isBankOwned)
        }
        
        if listingSubType["is_forAuction"] == true {
            let auctionType: AuctionType
            if description?.lowercased().contains("foreclosure") == true {
                auctionType = .foreclosure
            } else if description?.lowercased().contains("bank-owned") == true {
                auctionType = .bankOwned
            } else {
                auctionType = .standard
            }
            
            let startDate = priceHistory?.first(where: {
                $0.event?.lowercased().contains("auction") == true
            })?.date
            
            return .auction(type: auctionType, startDate: startDate)
        }
        
        if homeStatus == "RECENTLY_SOLD" || dateSold != nil {
            let soldPrice = priceHistory?.first(where: {
                $0.event?.lowercased() == "sold"
            })?.price
            return .sold(date: dateSold, price: soldPrice)
        }
        
        if let facts = propertyFacts as? [String: Any],
           let atAGlanceFacts = facts["atAGlanceFacts"] as? [[String: Any]],
           let typeInfo = atAGlanceFacts.first(where: { ($0["factLabel"] as? String) == "Type" }),
           let type = typeInfo["factValue"] as? String,
           type.lowercased().contains("room") ||
           (homeType == "APARTMENT" && (bedrooms == 0 || bedrooms == nil)) {
            return .roomForRent(type: type, price: price)
        }
        
        if homeStatus == "FOR_RENT" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let availableDate = availabilityDate.map {
                dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval($0/1000)))
            }
            return .forRent(price: price, availableDate: availableDate)
        }
        
        if listingSubType["is_newHome"] == true &&
           homeStatus == "FOR_SALE" &&
           (yearBuilt ?? 0) > Calendar.current.component(.year, from: Date()) {
            return .newConstruction
        }
        
        if homeStatus == "PENDING" || listingSubType["is_pending"] == true {
            let pendingDate = priceHistory?.first(where: {
                $0.event?.lowercased().contains("pending") == true
            })?.date
            return .pending(pendingDate)
        }
        
        if homeStatus == "FOR_SALE" &&
           (listingSubType["is_FSBA"] == true || listingSubType["is_FSBO"] == true) &&
           !datePosted.isEmpty {
            return .forSale(daysOnMarket: daysOnZillow)
        }
        
        print("× Falling through to .other status")
        return .other(homeStatus)
    }
}
