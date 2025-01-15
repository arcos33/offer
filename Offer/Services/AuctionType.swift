//
//  AuctionType.swift
//  Offer
//
//  Created by arkos33 on 12/27/24.
//

enum AuctionType: String, Codable, Equatable {
    case foreclosure
    case bankOwned
    case standard
    
    var description: String {
        switch self {
        case .foreclosure:
            return "foreclosure auction"
        case .bankOwned:
            return "bank-owned auction"
        case .standard:
            return "auction"
        }
    }
}
