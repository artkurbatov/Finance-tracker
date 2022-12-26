//
//  ViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 13.12.2022.
//

import UIKit

class FinanceViewController: UIViewController {
   
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let totalAmountLabel = UILabel()
    
    private let selectCurrency = UIButton()
    private let clearButton = UIButton()
    private let addButton = UIButton()
    
    private let historyTableView = UITableView()
    
    private let periodPicker: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Day", "Month", "Year", "All time"])
        view.selectedSegmentIndex = 3
        view.addTarget(self, action: #selector(sortTransactions), for: .valueChanged)
        return view
    }()
    
    private let feedback = UISelectionFeedbackGenerator()
    
    private let model = FinanceModel()
    private var filteredTransactions = [Transaction]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        historyTableView.delegate = self
        historyTableView.dataSource = self
        model.delegate = self
        
        feedback.prepare()
                
        model.fetchTransactions()
        
        filteredTransactions = model.transactions

        setupTitleLabel()
        configureCurrencyButton()
        setupPickerView()
        configureTableView()
        configureClearButton()
        configureAddButton()
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
    
    private func configureCurrencyButton() {
        
        view.addSubview(selectCurrency)
        
        selectCurrency.setImage(UIImage(systemName: "dollarsign"), for: .normal)
        
        selectCurrency.backgroundColor = .white
        selectCurrency.layer.cornerRadius = 5
        
        selectCurrency.tintColor = .black
        
        selectCurrency.addTarget(self, action: #selector(currencyAction), for: .touchUpInside)
        
        selectCurrency.translatesAutoresizingMaskIntoConstraints = false
        
        selectCurrency.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        selectCurrency.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
    }
    
    private func setupPickerView() {
        
        view.addSubview(periodPicker)
        
        periodPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            periodPicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            periodPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            periodPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    
    private func configureTableView() {
        
        view.addSubview(historyTableView)
        historyTableView.register(TransactionCell.self, forCellReuseIdentifier: FinanceModel.identifier)
        historyTableView.register(CustomFooter.self, forHeaderFooterViewReuseIdentifier: "footer")
        
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.allowsSelection = false
                
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        
        historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        historyTableView.topAnchor.constraint(equalTo: periodPicker.bottomAnchor, constant: 10).isActive = true
        historyTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
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
        clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
    }
    
    private func configureAddButton() {
        
        view.addSubview(addButton)
        
        addButton.configuration = .filled()
        addButton.configuration?.cornerStyle = .capsule
        addButton.configuration?.baseBackgroundColor = .systemBlue
        addButton.configuration?.baseForegroundColor = .white
        addButton.configuration?.title = "Add"
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
    }
    
    @objc private func currencyAction() {
        model.createTestTransaction()
        filteredTransactions = model.transactions
    }

    @objc private func addButtonAction() {
        
        let alert = UIAlertController(title: "New transaction", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.keyboardType = .numbersAndPunctuation
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if alert.textFields?[0] != nil && alert.textFields?[0].text != nil {
                let amount = alert.textFields![0].text!
                if let number = Double(amount) {
                    let dateString = self.model.getDateString()
                    self.model.saveTransactions(amount: number.round(to: 2), day: dateString.0, month: dateString.1, year: dateString.2)
                        //self.filteredTransactions = self.model.transactions
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
//        let alert = model.createAlert(tableView: historyTableView)
        present(alert, animated: true)
    }
    
#warning("picker doesn't work properly. For day it calculates number of satifying transactopns and takes this number of first transactions")
    @objc private func sortTransactions() {
        
        model.fetchTransactions()
    }
    
    @objc private func clearButtonAction() {
        if !model.transactions.isEmpty {
            model.clearTransactions()
            filteredTransactions = []
        }
    }
}

extension FinanceViewController: FinaceModelDelegate {
    
    func filterTransactions() {
        switch periodPicker.selectedSegmentIndex {
        case 0 :
            filteredTransactions = model.transactions.filter({ transaction in
                transaction.day + transaction.month + transaction.year == model.getDateString().0 + model.getDateString().1 + model.getDateString().2
            })
        case 1 :
            filteredTransactions = model.transactions.filter({ transaction in
                transaction.month == model.getDateString().1 && transaction.year == model.getDateString().2
            })
        case 2:
            filteredTransactions = model.transactions.filter({ transaction in
                transaction.year == model.getDateString().2
            })
           
        default:
            filteredTransactions = model.transactions
        }
    }
    
    func updateHistoryTableView() {
        historyTableView.reloadData()
    }
}


extension FinanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = historyTableView.dequeueReusableCell(withIdentifier: FinanceModel.identifier, for: indexPath) as? TransactionCell {
            cell.configureCell(transactionToDisplay: filteredTransactions[indexPath.row])
            return cell
        }
        else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            self.model.deleteTransaction(transactionID: indexPath.row)
            self.filteredTransactions = self.model.transactions
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = historyTableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as! CustomFooter
        let sum = model.calculateTotal(transactions: filteredTransactions)
        view.configure(summ: "\(sum) \(AppSettings.currency)")
        return view
    }
}

