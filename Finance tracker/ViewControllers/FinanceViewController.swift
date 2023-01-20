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
    
    private var clearButton: UIButton!
    private var addButton: UIButton!
    
    private let selectCurrencyButton = UIButton()
    private let sortButton = UIButton()
    
    private let historyTableView = UITableView()
    
    private let buttonWidth = UIDevice.current.userInterfaceIdiom == .phone ? 0.3 : 0.2
    private let buttonsSpacing: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 20 : 40
    
    private let periodPicker: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Day", "Month", "Year", "All time"])
        view.selectedSegmentIndex = 3
        view.addTarget(self, action: #selector(reloadTransactions), for: .valueChanged)
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
        
        model.loadTransactions()
        model.getUserCurrency()
        
        configureTitleLabel()
        configureCurrencyButton()
        configureSortButton()
        configurePickerView()
        configureTableView()
        configureClearButton()
        configureAddButton()
    }
    
    // MARK: - Views configureation
    
    private func configureTitleLabel() {
        
        view.addSubview(titleLabel)
        
        titleLabel.text = "Finance"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func configureCurrencyButton() {
        
        view.addSubview(selectCurrencyButton)
        
        model.setCurrencyImage(button: selectCurrencyButton)
        
        selectCurrencyButton.showsMenuAsPrimaryAction = true
        selectCurrencyButton.menu = model.selectCurrencyMenu(button: selectCurrencyButton)
    
        // Settings for dark mode
        selectCurrencyButton.backgroundColor = .white
        selectCurrencyButton.layer.cornerRadius = 5
        
        selectCurrencyButton.tintColor = .black
        
        selectCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectCurrencyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectCurrencyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            selectCurrencyButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureSortButton() {
        
        view.addSubview(sortButton)
        
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortTransaction), for: .touchUpInside)
        
        sortButton.backgroundColor = .white
        sortButton.layer.cornerRadius = 5
        
        sortButton.tintColor = .black
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: selectCurrencyButton.leadingAnchor, constant: -20),
            sortButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            sortButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configurePickerView() {
        
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
        
        NSLayoutConstraint.activate([
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.topAnchor.constraint(equalTo: periodPicker.bottomAnchor, constant: 10),
            historyTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func configureClearButton() {
        
        clearButton = model.createButton(bgColor: .systemRed, fgColor: .white, title: "Clear")
        
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
        
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonWidth),
            clearButton.heightAnchor.constraint(equalToConstant: 40),
            clearButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: buttonsSpacing * -1)
        ])
    }
    
    private func configureAddButton() {
        
        addButton = model.createButton(bgColor: .systemBlue, fgColor: .white, title: "Add")
        
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: buttonWidth),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: buttonsSpacing)
        ])
    }
    
    // MARK: - Button Actions
    
    @objc private func sortTransaction() {
        
        model.sortTransactions()
    }
        
    @objc private func addButtonAction() {
        
        let alert = model.createTransactionAlert()
        
        present(alert, animated: true)
    }
    
    @objc private func reloadTransactions() {
        
        model.loadTransactions()
    }
    
    @objc private func clearButtonAction() {
        
        if !model.transactions.isEmpty {
            let alert = model.createClearAlert()
            present(alert, animated: true)
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
            let transaction = self.filteredTransactions[indexPath.row]
            self.model.deleteTransaction(transactionID: transaction.id)
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

