import Foundation

struct ZillowPropertyResponse: Codable {
    // Private container for price history
    private let priceHistoryContainer: PriceHistoryContainer?
    private let taxHistoryContainer: TaxHistoryContainer?

    // Computed property to access price history
    var priceHistory: [PriceHistoryItem]? {
        if case .array(let items) = priceHistoryContainer {
            return items
        }
        return []
    }
    
    var taxHistory: [TaxHistoryItem]? {
        if case .array(let items) = taxHistoryContainer {
            return items
        }
        return []
    }
    
    let buildingPermits: String?
    let contactRecipients: [ContactRecipient]?
    let longitude: Double?
    let countyFIPS: String?
    let imgSrc: String?
    let livingAreaValue: Int?
    let streetAddress: String?
    let county: String?
    let monthlyHoaFee: Double?
    let timeZone: String?
    let dateSold: String?
    let annualHomeownersInsurance: Int?
    let state: String?
    let listedBy: ListedBy?
    let yearBuilt: Int?
    let brokerageName: String?
    let isListedByOwner: Bool?
    let climate: Climate?
    let latitude: Double?
    let nearbyHomes: [NearbyHome]?
    let schools: [School]?
    let rentZestimate: Int?
    let city: String?
    let providerListingID: String?
    let currency: String?
    let listingProvider: ListingProvider?
    let propertyTaxRate: Double?
    let openHouseSchedule: [String: String]?
    let mortgageRates: MortgageRates?
    let address: Address?
    let cityId: Int?
    let timeOnZillow: String?
    let url: String?
    let zestimate: Int?
    let zpid: Int
    let countyId: Int?
    let brokerId: Int?
    let livingAreaUnits: String?
    let comingSoonOnMarketDate: String?
    let bathrooms: Double?
    let building: String?
    let stateId: Int?
    let zipcode: String?
    let zestimateLowPercent: String?
    let price: Int?
    let attributionInfo: AttributionInfo?
    let homeStatus: String?
    let homeFacts: [String: String]?
    let resoFacts: ResoFacts?
    let datePosted: String?
    let bedrooms: Int?
    let propertyTypeDimension: String?
    let mortgageZHLRates: MortgageZHLRates?
    let pageViewCount: Int?
    let favoriteCount: Int?
    let listingSubType: [String: Bool]?
    let zestimateHighPercent: String?
    let mlsid: String?
    let description: String?
    let livingArea: Int?
    let buildingId: String?
    let country: String?
    let homeType: String?
    let solarPotential: String?
    let contingentListingType: String?
    
    private enum CodingKeys: String, CodingKey {
        case priceHistoryContainer = "priceHistory"
        case taxHistoryContainer = "taxHistory"
        case buildingPermits
        case contactRecipients
        case longitude
        case countyFIPS
        case imgSrc
        case livingAreaValue
        case streetAddress
        case county
        case monthlyHoaFee
        case timeZone
        case dateSold
        case annualHomeownersInsurance
        case state
        case listedBy
        case yearBuilt
        case brokerageName
        case isListedByOwner
        case climate
        case latitude
        case nearbyHomes
        case schools
        case rentZestimate
        case city
        case providerListingID
        case currency
        case listingProvider
        case propertyTaxRate
        case openHouseSchedule
        case mortgageRates
        case address
        case cityId
        case timeOnZillow
        case url
        case zestimate
        case zpid
        case countyId
        case brokerId
        case livingAreaUnits
        case comingSoonOnMarketDate
        case bathrooms
        case building
        case stateId
        case zipcode
        case zestimateLowPercent
        case price
        case attributionInfo
        case homeStatus
        case homeFacts
        case resoFacts
        case datePosted
        case bedrooms
        case propertyTypeDimension
        case mortgageZHLRates
        case pageViewCount
        case favoriteCount
        case listingSubType
        case zestimateHighPercent
        case mlsid
        case description
        case livingArea
        case buildingId
        case country
        case homeType
        case solarPotential
        case contingentListingType
    }
}

enum PriceHistoryContainer: Codable {
    case array([PriceHistoryItem])
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([PriceHistoryItem].self) {
            self = .array(array)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            self = .array([])
        }
    }
}

enum TaxHistoryContainer: Codable {
    case array([TaxHistoryItem])
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([TaxHistoryItem].self) {
            self = .array(array)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            self = .array([])
        }
    }
}
