//
//  CompanySectionViewModel.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 08/10/24.
//

import Foundation

class CompanySelectionViewModel {
    
    func extractData(forCompanyName companyName: String) -> FilterDatum? {
        if let filteredData = FilterDataManager.shared.filterData.first(where: { $0.companyName == companyName }) {
            return filteredData
        } else {
            print("Company name '\(companyName)' not found.")
            return nil
        }
    }
    
    func getMIDs(for companyName: String) -> [String] {
        guard let filterDatum = FilterDataManager.shared.filterData.first(where: { $0.companyName == companyName }) else {
            return []
        }
        
        var mids: [String] = []
        
        for hierarchyItem in filterDatum.hierarchy {
            for brand in hierarchyItem.brandNameList {
                for location in brand.locationNameList {
                    mids.append(contentsOf: location.merchantNumber.map { $0.mid })
                }
            }
        }
        
        return mids
    }
}
