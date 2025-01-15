//
//  PropertyStatus.swift
//  Offer
//
//  Created by arkos33 on 12/27/24.
//

enum PropertyStatus: Codable, Equatable {
    case offMarket
    case forSale(daysOnMarket: Int?)
    case pending(String?)
    case newConstruction
    case forRent(price: Int?, availableDate: String?)
    case roomForRent(type: String, price: Int?)
    case sold(date: String?, price: Int?)
    case auction(type: AuctionType, startDate: String?)
    case foreclosed(isBankOwned: Bool)
    case preForeclosure(estimatedValue: Int?)
    case other(String)
    
    private enum CodingKeys: String, CodingKey {
        case type, daysOnMarket, date, price, availableDate, roomType
        case auctionType, startDate, isBankOwned, estimatedValue, otherStatus
    }
    
    static func == (lhs: PropertyStatus, rhs: PropertyStatus) -> Bool {
        switch (lhs, rhs) {
        case (.offMarket, .offMarket):
            return true
        case let (.forSale(lhsDays), .forSale(rhsDays)):
            return lhsDays == rhsDays
        case let (.pending(lhsDate), .pending(rhsDate)):
            return lhsDate == rhsDate
        case (.newConstruction, .newConstruction):
            return true
        case let (.forRent(lhsPrice, lhsDate), .forRent(rhsPrice, rhsDate)):
            return lhsPrice == rhsPrice && lhsDate == rhsDate
        case let (.roomForRent(lhsType, lhsPrice), .roomForRent(rhsType, rhsPrice)):
            return lhsType == rhsType && lhsPrice == rhsPrice
        case let (.sold(lhsDate, lhsPrice), .sold(rhsDate, rhsPrice)):
            return lhsDate == rhsDate && lhsPrice == rhsPrice
        case let (.auction(lhsType, lhsDate), .auction(rhsType, rhsDate)):
            return lhsType == rhsType && lhsDate == rhsDate
        case let (.foreclosed(lhsValue), .foreclosed(rhsValue)):
            return lhsValue == rhsValue
        case let (.preForeclosure(lhsValue), .preForeclosure(rhsValue)):
            return lhsValue == rhsValue
        case let (.other(lhsStatus), .other(rhsStatus)):
            return lhsStatus == rhsStatus
        default:
            return false
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .offMarket:
            try container.encode("offMarket", forKey: .type)
        case .forSale(let days):
            try container.encode("forSale", forKey: .type)
            try container.encode(days, forKey: .daysOnMarket)
        case .pending(let date):
            try container.encode("pending", forKey: .type)
            try container.encode(date, forKey: .date)
        case .newConstruction:
            try container.encode("newConstruction", forKey: .type)
        case .forRent(let price, let date):
            try container.encode("forRent", forKey: .type)
            try container.encode(price, forKey: .price)
            try container.encode(date, forKey: .availableDate)
        case .roomForRent(let type, let price):
            try container.encode("roomForRent", forKey: .type)
            try container.encode(type, forKey: .roomType)
            try container.encode(price, forKey: .price)
        case .sold(let date, let price):
            try container.encode("sold", forKey: .type)
            try container.encode(date, forKey: .date)
            try container.encode(price, forKey: .price)
        case .auction(let type, let startDate):
            try container.encode("auction", forKey: .type)
            try container.encode(type, forKey: .auctionType)
            try container.encode(startDate, forKey: .startDate)
        case .foreclosed(let isBankOwned):
            try container.encode("foreclosed", forKey: .type)
            try container.encode(isBankOwned, forKey: .isBankOwned)
        case .preForeclosure(let value):
            try container.encode("preForeclosure", forKey: .type)
            try container.encode(value, forKey: .estimatedValue)
        case .other(let status):
            try container.encode("other", forKey: .type)
            try container.encode(status, forKey: .otherStatus)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "offMarket":
            self = .offMarket
        case "forSale":
            let days = try container.decodeIfPresent(Int.self, forKey: .daysOnMarket)
            self = .forSale(daysOnMarket: days)
        case "pending":
            let date = try container.decodeIfPresent(String.self, forKey: .date)
            self = .pending(date)
        case "newConstruction":
            self = .newConstruction
        case "forRent":
            let price = try container.decodeIfPresent(Int.self, forKey: .price)
            let date = try container.decodeIfPresent(String.self, forKey: .availableDate)
            self = .forRent(price: price, availableDate: date)
        case "roomForRent":
            let type = try container.decode(String.self, forKey: .roomType)
            let price = try container.decodeIfPresent(Int.self, forKey: .price)
            self = .roomForRent(type: type, price: price)
        case "sold":
            let date = try container.decodeIfPresent(String.self, forKey: .date)
            let price = try container.decodeIfPresent(Int.self, forKey: .price)
            self = .sold(date: date, price: price)
        case "auction":
            let auctionType = try container.decode(AuctionType.self, forKey: .auctionType)
            let startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
            self = .auction(type: auctionType, startDate: startDate)
        case "foreclosed":
            let isBankOwned = try container.decode(Bool.self, forKey: .isBankOwned)
            self = .foreclosed(isBankOwned: isBankOwned)
        case "preForeclosure":
            let value = try container.decodeIfPresent(Int.self, forKey: .estimatedValue)
            self = .preForeclosure(estimatedValue: value)
        case "other":
            let status = try container.decode(String.self, forKey: .otherStatus)
            self = .other(status)
        default:
            self = .other(type)
        }
    }
    
    var message: String {
        switch self {
        case .offMarket:
            return "This property is currently off the market"
        case .forSale(let days):
            if let days = days {
                return "This property is for sale (Listed for \(days) days)"
            }
            return "This property is for sale"
        case .pending(let date):
            if let date = date {
                return "This property sale is pending since \(date)"
            }
            return "This property sale is pending"
        case .newConstruction:
            return "This is a new construction property"
        case .forRent(let price, let date):
            var message = "This property is for rent"
            if let price = price {
                message += " at $\(price)/month"
            }
            if let date = date {
                message += " (Available from \(date))"
            }
            return message
        case .roomForRent(let type, let price):
            var message = "\(type)"
            if let price = price {
                message += " available for rent at $\(price)/month"
            }
            return message
        case .sold(let date, let price):
            var message = "This property has been sold"
            if let date = date {
                message += " on \(date)"
            }
            if let price = price {
                message += " for $\(price)"
            }
            return message
        case .auction(let type, let startDate):
            var message = "This property is available through \(type.description)"
            if let startDate = startDate {
                message += " starting \(startDate)"
            }
            return message
        case .foreclosed(let isBankOwned):
            if isBankOwned {
                return "This is a bank-owned foreclosed property"
            }
            return "This is a foreclosed property"
        case .preForeclosure(let value):
            var message = "This property is in pre-foreclosure status"
            if let value = value {
                message += " (Estimated value: $\(value))"
            }
            return message
        case .other(let status):
            return "Property status: \(status)"
        }
    }
}

extension PropertyStatus {
    var displayString: String {
        switch self {
        case .offMarket:
            return "Off Market"
        case .forSale(let daysOnMarket):
            return "For Sale" + (daysOnMarket.map { " (\($0) days)" } ?? "")
        case .forRent(let price, let availableDate):
            var text = "For Rent"
            if let price = price {
                text += " - $\(price)"
            }
            if let date = availableDate {
                text += " (Available \(date))"
            }
            return text
        case .sold(let date, let price):
            var text = "Sold"
            if let date = date {
                text += " on \(date)"
            }
            if let price = price {
                text += " for $\(price)"
            }
            return text
        case .pending(let date):
            var text = "Pending"
            if let date = date {
                text += " since \(date)"
            }
            return text
        case .preForeclosure(let estimatedValue):
            var text = "Pre-Foreclosure"
            if let value = estimatedValue {
                text += " (Estimated: $\(value))"
            }
            return text
        case .foreclosed(let isBankOwned):
            return isBankOwned ? "Bank Owned" : "Foreclosed"
        case .auction(let type, let startDate):
            var text = "Auction"
            switch type {
            case .foreclosure:
                text = "Foreclosure Auction"
            case .bankOwned:
                text = "Bank-Owned Auction"
            case .standard:
                text = "Standard Auction"
            }
            if let date = startDate {
                text += " (Starts \(date))"
            }
            return text
        case .roomForRent(let type, let price):
            var text = type
            if let price = price {
                text += " - $\(price)"
            }
            return text
        case .newConstruction:
            return "New Construction"
        case .other(let status):
            return status
        }
    }
}
