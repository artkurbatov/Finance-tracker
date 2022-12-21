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
    
    private let addButton = UIButton()
    private let clearButton = UIButton()
    
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
        
        feedback.prepare()
                
        model.fetchTransactions(tableView: historyTableView)
        
        filteredTransactions = model.transactions

        setupTitleLabel()
        setupAddButton()
        setupPickerView()
        configureTableView()
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
        
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 5
        
        addButton.tintColor = .black
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
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
        clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc private func addButtonAction() {
        
        let alert = UIAlertController(title: "New transaction", message: "", preferredStyle: .alert)
        
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if alert.textFields?[0] != nil && alert.textFields?[0].text != nil {
                var amount = alert.textFields![0].text!
                if let _ = Double(amount) {
                    if !amount.contains(".") {
                        amount += ".0"
                    }
                    // TODO: Change symbol for
                    //amount += " $"
                    let dateString = self.model.getDateString()
                    self.model.saveTransactions(amount: amount, date: dateString, tableView: self.historyTableView)
                    self.filteredTransactions = self.model.transactions
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
//        let alert = model.createAlert(tableView: historyTableView)
        present(alert, animated: true)
    }
    
    @objc private func sortTransactions() {
        feedback.selectionChanged()
        
        switch periodPicker.selectedSegmentIndex {
        case 0 :
            filteredTransactions = model.transactions.filter({ transaction in
                transaction.date == model.getDateString()
                //historyTableView.reloadData()
            })
        case 1 :
            filteredTransactions = model.transactions.filter({ transaction in
                transaction.date == model.getDateString()
                //historyTableView.reloadData()
            })
        case 2:
            view.backgroundColor = .systemPink
        default:
            view.backgroundColor = .orange
        }
        
    }
    
    @objc private func clearButtonAction() {
        if !model.transactions.isEmpty {
            model.clearTransactions(tableView: historyTableView)
            filteredTransactions = []
        }
    }
}


extension FinanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = historyTableView.dequeueReusableCell(withIdentifier: FinanceModel.identifier, for: indexPath) as? TransactionCell {
            cell.configureCell(transactionToDisplay: model.transactions[indexPath.row])
            return cell
        }
        else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            self.model.deleteTransaction(transactionID: indexPath.row, tableView: self.historyTableView)
            self.filteredTransactions = self.model.transactions
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = historyTableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as! CustomFooter
        let sum = model.calculateTotal(transactions: filteredTransactions)
        view.configure(summ: "\(sum) $")
        return view
    }
}

