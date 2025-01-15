//
//  YearAssesed.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

struct Property: Codable {
    var addressLine1: String
    var city: String
    var state: String
    var zipCode: String
    var county: String
    var bedrooms: Int
    var bathrooms: Int
    var lotSize: Int
    var yearBuilt: Int
    var propertyType: String
    var taxAssessment: [String: [String: Int]]
//    var owner: [String: [String: [names]]]
    var id: String
    var longitude: Float
    var latitude: Float
}

// MARK: - Hashable
extension Property: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id
    }
}
