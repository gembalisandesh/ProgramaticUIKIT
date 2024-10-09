//
//  FilterViewController.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 08/10/24.
//

import UIKit

class FilterViewController: UIViewController {

    private var companies: [String] = [] {
        didSet {
            print("Companies updated: \(companies)")
        }
    }
    private var selectedCompanyIndex: Int = 0 {
        didSet {
            print("Selected company index updated: \(selectedCompanyIndex)")
        }
    }

    private var viewModel = FilterViewModel()
    private var availableAccountNumbers: [String] = [] {
        didSet {
            print("Available account numbers updated: \(availableAccountNumbers)")
        }
    }
    private var availableBrands: [String] = [] {
        didSet {
            print("Available brands updated: \(availableBrands)")
        }
    }
    private var availableLocations: [String] = [] {
        didSet {
            print("Available locations updated: \(availableLocations)")
        }
    }

    private var selectedAccountNumbers: Set<String> = [] {
        didSet {
            print("Selected account numbers updated: \(selectedAccountNumbers)")
        }
    }
    private var selectedBrands: Set<String> = [] {
        didSet {
            print("Selected brands updated: \(selectedBrands)")
        }
    }
    private var selectedLocations: Set<String> = [] {
        didSet {
            print("Selected locations updated: \(selectedLocations)")
        }
    }

    private var selectedCompanyName: String? {
        didSet {
            print("Selected company name updated: \(selectedCompanyName ?? "nil")")
        }
    }

    private let filterOptions = ["Select Account Numbers", "Select Brands", "Select Locations"]
    private var filterCounts = [0, 0, 0] {
        didSet {
            print("Filter counts updated: \(filterCounts)")
        }
    }

    private let companyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = 44
        return tableView
    }()

    private let applyFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply Filter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Apply Filters"

        companies = FilterDataManager.shared.getCompanyNames()

        if !companies.isEmpty {
            selectedCompanyName = companies[0]
        }
        setupUI()
        filterTableView.dataSource = self
        filterTableView.delegate = self
        companyCollectionView.dataSource = self
        companyCollectionView.delegate = self

        companyCollectionView.register(CompanyCollectionViewCell.self, forCellWithReuseIdentifier: CompanyCollectionViewCell.reuseIdentifier)

        updateAvailableSelections()
    }

    private func setupUI() {
        view.addSubview(companyCollectionView)
        view.addSubview(filterTableView)
        view.addSubview(applyFilterButton)

        NSLayoutConstraint.activate([
            companyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            companyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            companyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            companyCollectionView.heightAnchor.constraint(equalToConstant: 50),

            filterTableView.topAnchor.constraint(equalTo: companyCollectionView.bottomAnchor, constant: 20),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterTableView.heightAnchor.constraint(equalToConstant: CGFloat(filterOptions.count * 44)),

            applyFilterButton.topAnchor.constraint(equalTo: filterTableView.bottomAnchor, constant: 40),
            applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func applyFilter() {
        print("Selected Company:", companies[selectedCompanyIndex])
        print("Selected Account Numbers:", Array(selectedAccountNumbers))
        print("Selected Brands:", Array(selectedBrands))
        print("Selected Locations:", Array(selectedLocations))

        let selectedCompany = companies[selectedCompanyIndex]

        let memberIds = viewModel.getFilteredMemberIDs(for: selectedCompany, selectedAccountNumbers: selectedAccountNumbers, selectedBrands: selectedBrands, selectedLocations: selectedLocations)

        print("Filtered Member IDs:", memberIds)

        let companySelectionVC = CompanySelectionViewController()
        companySelectionVC.companyName = selectedCompany
        companySelectionVC.merchantIds = memberIds
        companySelectionVC.modalPresentationStyle = .fullScreen
        present(companySelectionVC, animated: false, completion: nil)

    }

    private func updateAvailableSelections() {
        guard let selectedCompanyName = selectedCompanyName, !selectedCompanyName.isEmpty else {
            availableAccountNumbers = []
            availableBrands = []
            availableLocations = []
            filterCounts = [0, 0, 0]
            filterTableView.reloadData()
            print("No company selected. Default selections are applied.")
            return
        }

        let results = viewModel.getFilteredResults(
            for: selectedCompanyName,
            selectedAccountNumbers: selectedAccountNumbers,
            selectedBrands: selectedBrands,
            selectedLocations: selectedLocations
        )

        availableAccountNumbers = results.0
        availableBrands = results.1
        availableLocations = results.2

        filterCounts = [
            availableAccountNumbers.count,
            availableBrands.count,
            availableLocations.count
        ]

        filterTableView.reloadData()
        print("Available selections updated for company: \(selectedCompanyName)")
    }

    private func getFilteredResults() {
        print("Getting filtered results with:")
        print("Selected Account Numbers: \(Array(selectedAccountNumbers))")
        print("Selected Brands: \(Array(selectedBrands))")
        print("Selected Locations: \(Array(selectedLocations))")

        let results = viewModel.getFilteredResults(for: selectedCompanyName ?? "", selectedAccountNumbers: selectedAccountNumbers, selectedBrands: selectedBrands, selectedLocations: selectedBrands)

        availableAccountNumbers = results.0
        availableBrands = results.1
        availableLocations = results.2

        filterCounts = [
            availableAccountNumbers.count,
            availableBrands.count,
            availableLocations.count
        ]

        filterTableView.reloadData()
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        cell.textLabel?.text = filterOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator

        let countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        countLabel.text = "\(filterCounts[indexPath.row])"
        countLabel.textAlignment = .right
        cell.accessoryView = countLabel

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectionVC = SelectionViewController()
        selectionVC.modalPresentationStyle = .pageSheet
        if #available(iOS 16, *) {
            if let sheet = selectionVC.sheetPresentationController {
                sheet.detents = [
                    .custom { context in
                        return 300
                    }
                ]
                sheet.prefersGrabberVisible = true
            }
        } else {
            selectionVC.modalPresentationStyle = .overFullScreen
        }

        switch indexPath.row {
        case 0:
            selectionVC.options = availableAccountNumbers
            selectionVC.selectedOptions = Set(selectedAccountNumbers)
            selectionVC.selectionType = "Account Numbers"
        case 1:
            selectionVC.options = availableBrands
            selectionVC.selectedOptions = Set(selectedBrands)
            selectionVC.selectionType = "Brands"
        case 2:
            selectionVC.options = availableLocations
            selectionVC.selectedOptions = Set(selectedLocations)
            selectionVC.selectionType = "Locations"
        default:
            return
        }

        selectionVC.onSelectionCompleted = { [weak self] selected in
            guard let self = self else { return }

            switch indexPath.row {
            case 0:
                if self.selectedAccountNumbers != Set(selected) {
                    self.selectedAccountNumbers = Set(selected)
                    self.updateAvailableSelections()
                }
            case 1:
                if self.selectedBrands != Set(selected) {
                    self.selectedBrands = Set(selected)
                    self.updateAvailableSelections()
                }
            case 2:
                if self.selectedLocations != Set(selected) {
                    self.selectedLocations = Set(selected)
                    self.updateAvailableSelections()
                }
            default:
                break
            }
        }

        present(selectionVC, animated: true, completion: nil)
    }
}

extension FilterViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.reuseIdentifier, for: indexPath) as! CompanyCollectionViewCell
        let companyName = companies[indexPath.item]
        cell.configure(with: companyName, isSelected: indexPath.item == selectedCompanyIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCompanyIndex = indexPath.item
        selectedCompanyName = companies[selectedCompanyIndex]

        selectedAccountNumbers.removeAll()
        selectedBrands.removeAll()
        selectedLocations.removeAll()

        filterCounts = [0, 0, 0]

        collectionView.reloadData()

        updateAvailableSelections()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = companies[indexPath.item]
        let width = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 20
        return CGSize(width: width, height: 40)
    }
}
