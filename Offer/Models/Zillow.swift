//
//  Zillow.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

import Foundation

struct Zillow: Identifiable, Codable, Equatable {
    let id: UUID
    let zpid: Int
    let homeStatus: String
    let mlsid: String?
    let price: Double
    let bedrooms: Int?
    let bathrooms: Double
    let livingArea: Int
    let homeType: String
    let timeOnZillow: String?
    let yearBuilt: Int?
    let lotSize: Double
    let imgSrc: String?
    let streetAddress: String
    let city: String
    let state: String
    let zipcode: String
    let url: String
    let description: String?
    let architecturalStyle: String?
    let propertyStatus: PropertyStatus
    
    // NEW: Add static func == for Equatable conformance
    static func == (lhs: Zillow, rhs: Zillow) -> Bool {
        return lhs.id == rhs.id &&
               lhs.zpid == rhs.zpid &&
               lhs.homeStatus == rhs.homeStatus &&
               lhs.mlsid == rhs.mlsid &&
               lhs.price == rhs.price &&
               lhs.bedrooms == rhs.bedrooms &&
               lhs.bathrooms == rhs.bathrooms &&
               lhs.livingArea == rhs.livingArea &&
               lhs.homeType == rhs.homeType &&
               lhs.timeOnZillow == rhs.timeOnZillow &&
               lhs.yearBuilt == rhs.yearBuilt &&
               lhs.lotSize == rhs.lotSize &&
               lhs.imgSrc == rhs.imgSrc &&
               lhs.streetAddress == rhs.streetAddress &&
               lhs.city == rhs.city &&
               lhs.state == rhs.state &&
               lhs.zipcode == rhs.zipcode &&
               lhs.url == rhs.url &&
               lhs.description == rhs.description &&
               lhs.architecturalStyle == rhs.architecturalStyle &&
               lhs.propertyStatus == rhs.propertyStatus
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case zpid
        case homeStatus
        case mlsid
        case price
        case bedrooms
        case bathrooms
        case livingArea
        case homeType
        case timeOnZillow
        case yearBuilt
        case lotSize
        case imgSrc
        case streetAddress
        case city
        case state
        case zipcode
        case url
        case description
        case architecturalStyle
        case propertyStatus
    }
}

