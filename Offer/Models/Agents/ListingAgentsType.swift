//
//  ListingAgentsType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

enum ListingAgentsType: Codable {
    case dictionary([String: String])
    case array([ListingAgent])
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else if let array = try? container.decode([ListingAgent].self) {
            self = .array(array)
        } else if container.decodeNil() {
            self = .null
        } else {
            self = .dictionary([:])
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dictionary(let dict):
            try container.encode(dict)
        case .array(let array):
            try container.encode(array)
        case .null:
            try container.encodeNil()
        }
    }
}
