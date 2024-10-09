//
//  FilterViewModel.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 08/10/24.
//

import Foundation

class FilterViewModel {
    private weak var dataManager = FilterDataManager.shared
    private weak var memberDataManager = MemberIdDataManager.shared
    
    func getAccountNumbers(for companyIndex: Int) -> [String] {
        guard let filterData = dataManager?.filterData, companyIndex < filterData.count else { return [] }
        return filterData[companyIndex].accountList
    }
    
    func getBrands(for companyIndex: Int) -> [String] {
        guard let filterData = dataManager?.filterData, companyIndex < filterData.count else { return [] }
        return filterData[companyIndex].brandList
    }
    
    func getLocations(for companyIndex: Int) -> [String] {
        guard let filterData = dataManager?.filterData, companyIndex < filterData.count else { return [] }
        return filterData[companyIndex].locationList
    }
    
    func getFilteredResults(for companyName: String, selectedAccountNumbers: Set<String>, selectedBrands: Set<String>, selectedLocations: Set<String>) -> ([String], [String], [String]) {
        
        if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            return getAllDataByCompanyName(companyName: companyName)
        }
        
        var filteredAccountNumbers: Set<String> = []
        var filteredBrands: Set<String> = []
        var filteredLocations: Set<String> = []
        
        if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            let result = getDataByAccountNumbers(companyName: companyName, accountNumbers: Array(selectedAccountNumbers))
            filteredAccountNumbers = selectedAccountNumbers
            filteredBrands = Set(result.brands)
            filteredLocations = Set(result.locations)
        } else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            let result = getDataByBrands(companyName: companyName, brands: Array(selectedBrands))
            filteredAccountNumbers = Set(result.accountNumbers)
            filteredBrands = selectedBrands
            filteredLocations = Set(result.locations)
        } else if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let result = getDataByLocations(companyName: companyName, locations: Array(selectedLocations))
            filteredAccountNumbers = Set(result.accountNumbers)
            filteredBrands = Set(result.brands)
            filteredLocations = selectedLocations
        } else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            let accountResult = getDataByAccountNumbers(companyName: companyName, accountNumbers: Array(selectedAccountNumbers))
            let brandResult = getDataByBrands(companyName: companyName, brands: Array(selectedBrands))
            filteredAccountNumbers = selectedAccountNumbers.intersection(Set(brandResult.accountNumbers))
            filteredBrands = selectedBrands.intersection(Set(accountResult.brands))
            filteredLocations = Set(getLocationsByAccountNumbersAndBrands(companyName: companyName, accountNumbers: Array(filteredAccountNumbers), brands: Array(filteredBrands)))
        } else if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let accountResult = getDataByAccountNumbers(companyName: companyName, accountNumbers: Array(selectedAccountNumbers))
            let locationResult = getDataByLocations(companyName: companyName, locations: Array(selectedLocations))
            filteredAccountNumbers = selectedAccountNumbers.intersection(Set(locationResult.accountNumbers))
            filteredLocations = selectedLocations.intersection(Set(accountResult.locations))
            filteredBrands = Set(getBrandsByAccountNumbersAndLocations(companyName: companyName, accountNumbers: Array(filteredAccountNumbers), locations: Array(filteredLocations)))
        } else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let brandResult = getDataByBrands(companyName: companyName, brands: Array(selectedBrands))
            let locationResult = getDataByLocations(companyName: companyName, locations: Array(selectedLocations))
            filteredBrands = selectedBrands.intersection(Set(locationResult.brands))
            filteredLocations = selectedLocations.intersection(Set(brandResult.locations))
            filteredAccountNumbers = Set(getAccountNumbersByBrandsAndLocations(companyName: companyName, brands: Array(filteredBrands), locations: Array(filteredLocations)))
        } else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let accountResult = getDataByAccountNumbers(companyName: companyName, accountNumbers: Array(selectedAccountNumbers))
            let brandResult = getDataByBrands(companyName: companyName, brands: Array(selectedBrands))
            let locationResult = getDataByLocations(companyName: companyName, locations: Array(selectedLocations))
            
            filteredAccountNumbers = selectedAccountNumbers
                .intersection(Set(brandResult.accountNumbers))
                .intersection(Set(locationResult.accountNumbers))
            
            filteredBrands = selectedBrands
                .intersection(Set(accountResult.brands))
                .intersection(Set(locationResult.brands))
            
            filteredLocations = selectedLocations
                .intersection(Set(accountResult.locations))
                .intersection(Set(brandResult.locations))
        }
        
        if filteredAccountNumbers.count < selectedAccountNumbers.count {
            filteredAccountNumbers = selectedAccountNumbers
        }
        
        if filteredBrands.count < selectedBrands.count {
            filteredBrands = selectedBrands
        }
        
        if filteredLocations.count < selectedLocations.count {
            filteredLocations = selectedLocations
        }
        
        return (Array(filteredAccountNumbers), Array(filteredBrands), Array(filteredLocations))
    }
    
    func getFilteredMemberIDs(for companyName: String, selectedAccountNumbers: Set<String>, selectedBrands: Set<String>, selectedLocations: Set<String>) -> [String] {
        
        if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            return memberDataManager?.getMemberIDs(forCompanyName: companyName) ?? []
        }
        
        var memberIDs: Set<String> = []
        
        if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers)) ?? [])
        }
        
        else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forBrands: Array(selectedBrands)) ?? [])
        }
        
        else if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forLocations: Array(selectedLocations)) ?? [])
        }
        
        else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), brands: Array(selectedBrands)) ?? [])
        }
        
        else if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), locations: Array(selectedLocations)) ?? [])
        }
        
        else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(memberDataManager?.getMemberIDs(forBrands: Array(selectedBrands)) ?? [])
                .intersection(Set(memberDataManager?.getMemberIDs(forLocations: Array(selectedLocations)) ?? []))
        }
        
        else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let accountBrandMemberIDs = Set(memberDataManager?.getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), brands: Array(selectedBrands)) ?? [])
            let locationMemberIDs = Set(memberDataManager?.getMemberIDs(forLocations: Array(selectedLocations)) ?? [])
            memberIDs = accountBrandMemberIDs.intersection(locationMemberIDs)
        }
        
        return Array(memberIDs)
    }
    
    func getDataByAccountNumbers(companyName: String, accountNumbers: [String]) -> (brands: [String], locations: [String]) {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return ([], [])
        }
        
        let filteredHierarchy = company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
        let brands = Array(Set(filteredHierarchy.flatMap { $0.brandNameList.map { $0.brandName } }))
        let locations = Array(Set(filteredHierarchy.flatMap { $0.brandNameList.flatMap { $0.locationNameList.map { $0.locationName } } }))
        
        return (brands, locations)
    }
    
    func getLocationsByAccountNumbersAndBrands(companyName: String, accountNumbers: [String], brands: [String]) -> [String] {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return []
        }
        
        let filteredHierarchy = company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
        let locations = filteredHierarchy.flatMap { account in
            account.brandNameList
                .filter { brands.contains($0.brandName) }
                .flatMap { $0.locationNameList.map { $0.locationName } }
        }
        
        return Array(Set(locations))
    }
    
    func getBrandsByAccountNumbersAndLocations(companyName: String, accountNumbers: [String], locations: [String]) -> [String] {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return []
        }
        
        let filteredHierarchy = company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
        let brands = filteredHierarchy.flatMap { account in
            account.brandNameList
                .filter { brand in
                    brand.locationNameList.contains(where: { locations.contains($0.locationName) })
                }
                .map { $0.brandName }
        }
        
        return Array(Set(brands))
    }
    
    func getAccountNumbersByBrandsAndLocations(companyName: String, brands: [String], locations: [String]) -> [String] {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return []
        }
        
        let filteredHierarchy = company.hierarchy
        let accountNumbers = filteredHierarchy.flatMap { account in
            account.brandNameList
                .filter { brands.contains($0.brandName) && $0.locationNameList.contains(where: { locations.contains($0.locationName) }) }
                .map { _ in account.accountNumber }
        }
        
        return Array(Set(accountNumbers))
    }
    
    func getDataByBrands(companyName: String, brands: [String]) -> (accountNumbers: [String], locations: [String]) {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return ([], [])
        }
        
        let filteredHierarchy = company.hierarchy.filter { account in
            account.brandNameList.contains(where: { brands.contains($0.brandName) })
        }
        
        let accountNumbers = filteredHierarchy.map { $0.accountNumber }
        let locations = Array(Set(filteredHierarchy.flatMap { account in
            account.brandNameList.flatMap { $0.locationNameList.map { $0.locationName } }
        }))
        
        return (accountNumbers, locations)
    }
    
    func getDataByLocations(companyName: String, locations: [String]) -> (accountNumbers: [String], brands: [String]) {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return ([], [])
        }
        
        let filteredHierarchy = company.hierarchy.filter { account in
            account.brandNameList.contains(where: { brand in
                brand.locationNameList.contains(where: { locations.contains($0.locationName) })
            })
        }
        
        let accountNumbers = filteredHierarchy.map { $0.accountNumber }
        let brands = Array(Set(filteredHierarchy.flatMap { account in
            account.brandNameList.map { $0.brandName }
        }))
        
        return (accountNumbers, brands)
    }
    
    func getAllDataByCompanyName(companyName: String) -> (accountNumbers: [String], brands: [String], locations: [String]) {
        guard let company = dataManager?.filterData.first(where: { $0.companyName == companyName }) else {
            return ([], [], [])
        }
        
        let accountNumbers = company.hierarchy.map { $0.accountNumber }
        let brands = Array(Set(company.hierarchy.flatMap { account in
            account.brandNameList.map { $0.brandName }
        }))
        let locations = Array(Set(company.hierarchy.flatMap { account in
            account.brandNameList.flatMap { $0.locationNameList.map { $0.locationName } }
        }))
        
        return (accountNumbers, brands, locations)
    }
}
