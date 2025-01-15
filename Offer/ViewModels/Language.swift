//
//  Language.swift
//  Offer
//
//  Created by arkos33 on 12/21/24.
//

enum Language {
    case english
    case spanish
    case portuguese
    
    func stringDescription() -> String {
        switch self {
        case .english:
            return "en"
        case .spanish:
            return "es"
        case .portuguese:
            return "pt-br"
        }
    }
}
