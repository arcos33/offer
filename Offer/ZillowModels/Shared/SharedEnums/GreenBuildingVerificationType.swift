//
//  GreenBuildingVerificationType.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

enum GreenBuildingVerificationType: Codable {
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else {
            self = .string("")
        }
    }
}
