//
//  FilterDataManager.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 08/10/24.
//


import Foundation

class FilterDataManager {
    static let shared = FilterDataManager()
    var filterData: [FilterDatum] = []
    
    private init() {
        loadFilterData(from: jsonString)
    }
    
    func loadFilterData(from jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Invalid JSON format")
            return
        }
        
        do {
            let welcome = try JSONDecoder().decode(Welcome.self, from: jsonData)
            self.filterData = welcome.filterData
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    func getCompanyNames() -> [String] {
        return filterData.map { $0.companyName }
    }
    
    func getFilterOptions(for companyName: String) -> (accountNumbers: [String], brands: [String], locations: [String]) {
        guard let filterDatum = filterData.first(where: { $0.companyName == companyName }) else {
            return ([], [], [])
        }

        return (filterDatum.accountList, filterDatum.brandList, filterDatum.locationList)
    }
}
