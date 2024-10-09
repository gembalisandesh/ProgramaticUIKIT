//
//  MemberIDRetriever.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 09/10/24.
//


import Foundation

class MemberIdDataManager {
    static let shared = MemberIdDataManager()
    
    
    func getFilteredMemberIDs(for companyName: String, selectedAccountNumbers: Set<String>, selectedBrands: Set<String>, selectedLocations: Set<String>) -> [String] {
        if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            return getMemberIDs(forCompanyName: companyName)
        }
        
        var memberIDs: Set<String> = []
        
        if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers)))
        } else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forBrands: Array(selectedBrands)))
        } else if selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forLocations: Array(selectedLocations)))
        } else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), brands: Array(selectedBrands)))
        } else if !selectedAccountNumbers.isEmpty && selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), locations: Array(selectedLocations)))
        } else if selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            memberIDs = Set(getMemberIDs(forBrands: Array(selectedBrands)))
                .intersection(Set(getMemberIDs(forLocations: Array(selectedLocations))))
        } else if !selectedAccountNumbers.isEmpty && !selectedBrands.isEmpty && !selectedLocations.isEmpty {
            let accountBrandMemberIDs = Set(getMemberIDs(forAccountNumbers: Array(selectedAccountNumbers), brands: Array(selectedBrands)))
            let locationMemberIDs = Set(getMemberIDs(forLocations: Array(selectedLocations)))
            memberIDs = accountBrandMemberIDs.intersection(locationMemberIDs)
        }
        
        return Array(memberIDs)
    }
    
    func getMemberIDs(forAccountNumbers accountNumbers: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
                .flatMap { account in
                    account.brandNameList.flatMap { brand in
                        brand.locationNameList.flatMap { location in
                            location.merchantNumber.compactMap { $0.mid }
                        }
                    }
                }
        }
    }
    
    func getMemberIDs(forAccountNumbers accountNumbers: [String], brands: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
                .flatMap { account in
                    account.brandNameList.filter { brands.contains($0.brandName) }
                        .flatMap { brand in
                            brand.locationNameList.flatMap { location in
                                location.merchantNumber.compactMap { $0.mid }
                            }
                        }
                }
        }
    }
    
    func getMemberIDs(forBrands brands: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.flatMap { account in
                account.brandNameList.filter { brands.contains($0.brandName) }
                    .flatMap { brand in
                        brand.locationNameList.flatMap { location in
                            location.merchantNumber.compactMap { $0.mid }
                        }
                    }
            }
        }
    }
    
    func getMemberIDs(forLocations locations: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.flatMap { account in
                account.brandNameList.flatMap { brand in
                    brand.locationNameList.filter { locations.contains($0.locationName) }
                        .flatMap { location in
                            location.merchantNumber.compactMap { $0.mid }
                        }
                }
            }
        }
    }
    
    func getMemberIDs(forBrands brands: [String], locations: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.flatMap { account in
                account.brandNameList.filter { brands.contains($0.brandName) }
                    .flatMap { brand in
                        brand.locationNameList.filter { locations.contains($0.locationName) }
                            .flatMap { location in
                                location.merchantNumber.compactMap { $0.mid }
                            }
                    }
            }
        }
    }
    
    func getMemberIDs(forAccountNumbers accountNumbers: [String], locations: [String]) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.flatMap { company in
            company.hierarchy.filter { accountNumbers.contains($0.accountNumber) }
                .flatMap { account in
                    account.brandNameList.flatMap { brand in
                        brand.locationNameList.filter { locations.contains($0.locationName) }
                            .flatMap { location in
                                location.merchantNumber.compactMap { $0.mid }
                            }
                    }
                }
        }
    }
    
    func getMemberIDs(forCompanyName companyName: String) -> [String] {
        let filterData = FilterDataManager.shared.filterData
        return filterData.filter { $0.companyName == companyName }
            .flatMap { company in
                company.hierarchy.flatMap { account in
                    account.brandNameList.flatMap { brand in
                        brand.locationNameList.flatMap { location in
                            location.merchantNumber.compactMap { $0.mid }
                        }
                    }
                }
            }
    }
}
