//
//  ViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 13.12.2022.
//

import UIKit

class FinanceViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let total = UILabel()
    private let messageLabel = UILabel()
    private let totalAmountLabel = UILabel()
    
    private let addButton = UIButton()
    private let clearButton = UIButton()
    
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
        //configureTotalLabel()
        configureClearButton()
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
        view.addSubview(total)
        
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.allowsSelection = false
                
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        historyTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        historyTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    private func configureTotal() {
        
        
        
    }
    
    private func configureTotalLabel() {
        
        view.addSubview(total)
        
        total.text = "Total: 13.10$"
        total.font = UIFont.boldSystemFont(ofSize: 20)
        
        total.translatesAutoresizingMaskIntoConstraints = false
        
        //total.topAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 20).isActive = true
        //total.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        //total.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        total.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        total.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureClearButton() {
        
        view.addSubview(clearButton)
        
        clearButton.configuration = .filled()
        clearButton.configuration?.cornerStyle = .capsule
        clearButton.configuration?.baseBackgroundColor = .systemRed
        clearButton.configuration?.baseForegroundColor = .white
        clearButton.configuration?.title = "Clear"
        
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        clearButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc private func addButtonAction() {
        let alert = model.createAlert(tableView: historyTableView)
        present(alert, animated: true)
    }
    
    @objc private func clearButtonAction() {
        model.clearTransactions(tableView: historyTableView)
    }
}

extension FinanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = historyTableView.dequeueReusableCell(withIdentifier: FinanceModel.identifier, for: indexPath) as? TransactionCell {
            cell.configureCell(transactionToDisplay: model.transactions[indexPath.row])
            return cell
        }
        else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "Total: 14.13$"
    }
}

