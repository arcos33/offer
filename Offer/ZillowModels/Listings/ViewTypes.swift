//
//  ViewTypes.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


enum ViewTypes: Codable {
    case dictionary([String: String])
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dictionaryValue = try? container.decode([String: String].self) {
            self = .dictionary(dictionaryValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            self = .dictionary([:])
        }
    }
}