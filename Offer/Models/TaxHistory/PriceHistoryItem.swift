//
//  PriceHistoryItem.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


struct PriceHistoryItem: Codable {
    let priceChangeRate: Double?
    let date: String?
    let source: String?
    let postingIsRental: Bool?
    let time: Int?
    let pricePerSquareFoot: Int?
    let event: String?
    let price: Int?
}