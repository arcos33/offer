//
//  PrimarySource.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

struct PrimarySource: Codable {
    let insuranceRecommendation: String?
    let riskScore: RiskScore?
    let probability: ProbabilityType? // Custom type that can handle both formats
    let source: Source?
    let insuranceSeparatePolicy: String?
    let historicCountAll: Int?
}
