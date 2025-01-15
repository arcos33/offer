//
//  ProfitabilityType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

enum ProbabilityType: Codable {
    case array([Probability])
    case dictionary([String: Double])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let arrayValue = try? container.decode([Probability].self) {
            self = .array(arrayValue)
        } else if let dictValue = try? container.decode([String: Double].self) {
            self = .dictionary(dictValue)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected either array of Probability or dictionary"
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let array):
            try container.encode(array)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}
