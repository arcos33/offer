//
//  ListingProvider.swift
//  Offer
//
//  Created by arkos33 on 1/14/25.
//


struct ListingProvider: Codable {
    let enhancedVideoURL: String?
    let showNoContactInfoMessage: Bool?
    let postingGroupName: String?
    let isZRMSourceText: Bool?
    let showLogos: Bool?
    let logos: [String: String]?
    let sourceText: String?
    let title: String?
    let disclaimerText: String?
    let postingWebsiteURL: String?
    let agentLicenseNumber: String?
    let postingWebsiteLinkText: String?
    let enhancedDescriptionText: String?
    let agentName: String?
}