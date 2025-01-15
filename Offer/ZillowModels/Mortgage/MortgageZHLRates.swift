//
//  MortgageZHLRates.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


struct MortgageZHLRates: Codable {
    let thirtyYearFixedBucket: RateBucket?
    let fifteenYearFixedBucket: RateBucket?
    let arm5Bucket: RateBucket?
}