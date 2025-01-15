//
//  FoundationDetailsType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

enum FoundationDetailsType: Codable {
    case dictionary([String: String])
    case array([String])
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let dictValue = try? container.decode([String: String].self) {
            self = .dictionary(dictValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else if container.decodeNil() {
            self = .null
        } else {
            self = .null
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
