//
//  ApplianceType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


enum ApplianceType: Codable {
    case dictionary([String: String])
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else {
            self = .dictionary([:])
        }
    }
}