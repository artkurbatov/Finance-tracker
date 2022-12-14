//
//  ViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 13.12.2022.
//

import UIKit

class FinanceViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let addButton = UIButton()
    private let historyTableView = UITableView()
   // private let periodPicker = UIPickerView()
    
    private let model = FinanceModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(TransactionCell.self, forCellReuseIdentifier: FinanceModel.identifier)
        
        model.fetchTransactions(tableView: historyTableView)

        setupTitleLabel()
        setupAddButton()
        configureTableView()
    }
    
    // MARK: - Views setup

    private func setupTitleLabel() {
        
        view.addSubview(titleLabel)
        
        titleLabel.text = "Finance"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupAddButton() {
        
        view.addSubview(addButton)
        
        addButton.setImage(UIImage(systemName: "plus.forwardslash.minus"), for: .normal)
        
        
        addButton.tintColor = .black
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
    }
    
    private func configureTableView() {
        
        view.addSubview(historyTableView)
        
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        historyTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }

    @objc private func addButtonAction() {
        let alert = model.createAlert(tableView: historyTableView)
        present(alert, animated: true)
    }
}


extension FinanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = historyTableView.dequeueReusableCell(withIdentifier: FinanceModel.identifier, for: indexPath) as? TransactionCell {
            cell.configureCell(transactionToDisplay: model.transactions[indexPath.row])
        }
        return UITableViewCell()
    }
}

