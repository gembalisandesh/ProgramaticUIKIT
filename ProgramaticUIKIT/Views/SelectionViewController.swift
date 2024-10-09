//
//  SelectionViewController.swift
//  ProgramaticUIKIT
//
//  Created by Equipp on 09/10/24.
//


import UIKit

class SelectionViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    private let selectAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select All", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()

    var onSelectionCompleted: ((Set<String>) -> Void)?

    var selectionType: String = ""
    var options: [String] = []
    var selectedOptions: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupActions()
        titleLabel.text = selectionType
        
    }

    private func setupViews() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(selectAllButton)
        view.addSubview(tableView)
        view.addSubview(applyButton)

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            selectAllButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            selectAllButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: selectAllButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16),

            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupActions() {
        selectAllButton.addTarget(self, action: #selector(selectAllTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
    }

    @objc private func selectAllTapped() {
        if selectedOptions.count == options.count {
            selectedOptions.removeAll()
            selectAllButton.setTitle("Select All", for: .normal)
            selectAllButton.setTitleColor(.systemBlue, for: .normal)
        } else {
            selectedOptions = Set(options)
            selectAllButton.setTitle("Deselect All", for: .normal)
            selectAllButton.setTitleColor(.systemRed, for: .normal)
        }
        tableView.reloadData()
    }

    @objc private func applyTapped() {
        onSelectionCompleted?(selectedOptions)
        dismiss(animated: true, completion: nil)
    }
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let option = options[indexPath.row]
        cell.textLabel?.text = option

        cell.accessoryType = selectedOptions.contains(option) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        if selectedOptions.contains(selectedOption) {
            selectedOptions.remove(selectedOption)
        } else {
            selectedOptions.insert(selectedOption)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
