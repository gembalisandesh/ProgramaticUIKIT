// CompanySelectionViewController.swift
// ProgramaticUIKIT
//
// Created by Equipp on 08/10/24.

import UIKit

class CompanySelectionViewController: UIViewController {

    private let viewModel = CompanySelectionViewModel()

    var companyName: String? {
        didSet {
            companyLabel.text = companyName
        }
    }

    var merchantIds: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Select a Company"
        return label
    }()

    private let tapToChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap To Change"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    private let downArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let arrowImage = UIImage(systemName: "chevron.down")
        button.setImage(arrowImage, for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapChangeButton), for: .touchUpInside)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        tableView.dataSource = self
        tableView.delegate = self

        setupDefaultData()
    }

    private func setupDefaultData() {
        if (companyName?.isEmpty ?? true) && merchantIds.isEmpty {
            companyName = "CITY CENTRE COMMERCIAL CO.KSC"
            DispatchQueue.global(qos: .userInitiated).async {
                let fetchedMerchantIds = self.viewModel.getMIDs(for: self.companyName ?? "CITY CENTRE COMMERCIAL CO.KSC")
                DispatchQueue.main.async {
                    self.merchantIds = fetchedMerchantIds
                }
            }
        }
    }

    private func setupUI() {
        view.addSubview(companyLabel)
        view.addSubview(tapToChangeLabel)
        view.addSubview(downArrowButton)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            companyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            companyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tapToChangeLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 8),
            tapToChangeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            downArrowButton.centerYAnchor.constraint(equalTo: tapToChangeLabel.centerYAnchor),
            downArrowButton.leadingAnchor.constraint(equalTo: tapToChangeLabel.trailingAnchor, constant: 8),

            tableView.topAnchor.constraint(equalTo: tapToChangeLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapChangeButton() {
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .pageSheet

        if #available(iOS 16, *) {
            if let sheet = filterVC.sheetPresentationController {
                sheet.detents = [.custom { context in return 300 }]
                sheet.prefersGrabberVisible = true
            }
        } else {
            filterVC.modalPresentationStyle = .overFullScreen
        }

        present(filterVC, animated: true)
    }
}

extension CompanySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchantIds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        cell.textLabel?.text = merchantIds[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMerchantId = merchantIds[indexPath.row]
        print("Selected Merchant ID: \(selectedMerchantId)")
    }
}
