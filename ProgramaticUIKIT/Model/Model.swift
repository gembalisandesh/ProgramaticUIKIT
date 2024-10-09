//
//  Model.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 08/10/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    var status, message, errorCode: String
    var filterData: [FilterDatum]
}

// MARK: - FilterDatum
struct FilterDatum: Codable {
    var cif: String
    var companyName: String
    var accountList, brandList, locationList: [String]
    var hierarchy: [Hierarchy]

    enum CodingKeys: String, CodingKey {
        case cif = "Cif"
        case companyName, accountList, brandList, locationList, hierarchy
    }
}


// MARK: - Hierarchy
struct Hierarchy: Codable {
    var accountNumber: String
    var brandNameList: [BrandNameList]
}

// MARK: - BrandNameList
struct BrandNameList: Codable {
    var brandName: String
    var locationNameList: [LocationNameList]
}

// MARK: - LocationNameList
struct LocationNameList: Codable {
    var locationName: String
    var merchantNumber: [MerchantNumber]
}

// MARK: - MerchantNumber
struct MerchantNumber: Codable {
    var mid: String
    var outletNumber: [String]
}
