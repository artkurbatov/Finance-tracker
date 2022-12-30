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
    
    private let selectCurrencyButton = UIButton()
    private let clearButton = UIButton()
    private let addButton = UIButton()
    private let sortButton = UIButton()
    
    private let historyTableView = UITableView()
    
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
    
        setupTitleLabel()
        configureCurrencyButton()
        configureSortButton()
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
        
        view.addSubview(selectCurrencyButton)
        
        //TODO: Consider replacing this function
        model.setCurrencyImage(button: selectCurrencyButton)
        
        selectCurrencyButton.showsMenuAsPrimaryAction = true
        selectCurrencyButton.menu = model.selectCurrencyMenu(button: selectCurrencyButton)
        
        //selectCurrencyButton.addTarget(self, action: #selector(selectCurrencyAction), for: .touchUpInside)
        
        // Settings for dark mode
        selectCurrencyButton.backgroundColor = .white
        selectCurrencyButton.layer.cornerRadius = 5
        
        selectCurrencyButton.tintColor = .black
            
        selectCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        selectCurrencyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        selectCurrencyButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        selectCurrencyButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func configureSortButton() {
        
        view.addSubview(sortButton)
        
        sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortTransaction), for: .touchUpInside)
        
        sortButton.backgroundColor = .white
        sortButton.layer.cornerRadius = 5
        
        sortButton.tintColor = .black
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        sortButton.trailingAnchor.constraint(equalTo: selectCurrencyButton.leadingAnchor, constant: -20).isActive = true
        sortButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
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
    
    @objc private func sortTransaction() {
        
        model.sortTransactions()
    }
    
    @objc private func selectCurrencyAction() {
        
        let selectCurrencyVC = SelectCurrencyViewController()
        
        if let sheet = selectCurrencyVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(selectCurrencyVC, animated: true)
    }
    
    @objc private func addButtonAction() {
        
        let alert = model.createAlert()
        
     //   model.createTestTransaction()
        
        present(alert, animated: true)
    }
    
    @objc private func reloadTransactions() {
        
        model.loadTransactions()
    }
    
    @objc private func clearButtonAction() {
        if !model.transactions.isEmpty {
            model.clearTransactions()
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

