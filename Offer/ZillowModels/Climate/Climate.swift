//
//  Climate.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//

struct Climate: Codable {
    let windSources: ClimateSource?
    let floodSources: ClimateSource?
    let fireSources: ClimateSource?
    let heatSources: ClimateSource?
    let airSources: ClimateSource?
}
