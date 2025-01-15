//
//  RoadSurfaceType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


enum RoadSurfaceType: Codable {
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let arrayValue = try? container.decode([String].self) {
            self = .array(arrayValue)
        } else {
            self = .string("")
        }
    }
}