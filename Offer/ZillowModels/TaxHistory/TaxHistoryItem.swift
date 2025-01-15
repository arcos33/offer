//
//  TaxHistoryItem.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

struct TaxHistoryItem: Codable {
    let time: Int?
    let valueIncreaseRate: Double?
    let taxIncreaseRate: Double?
    let taxPaid: Double?
    let value: Int?
}
