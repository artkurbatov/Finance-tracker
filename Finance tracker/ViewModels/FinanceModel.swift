//
//  FinanceModel.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 14.12.2022.
//

import UIKit
import Foundation
import CoreData

class FinanceModel {
    
    #warning("max 2 digits after dot")
    
    static let identifier = "transactionCell"
    
    var transactions = [Transaction]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func createAlert(tableView: UITableView) -> UIAlertController {
        
        let alert = UIAlertController(title: "New transaction", message: "", preferredStyle: .alert)
        
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if alert.textFields?[0] != nil && alert.textFields?[0].text != nil {
                var amount = alert.textFields![0].text!
                if let _ = Double(amount) {
                    if !amount.contains(".") {
                        amount += ".00"
                    }
                    // TODO: Change symbol for
                    //amount += " $"
                    let dateString = self.getDateString()
                    self.saveTransactions(amount: amount, date: dateString, tableView: tableView)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    
    private func getDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = Date()
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    
    func calculateTotal(transactions: [Transaction]) -> Double {
        
        var total = 0.0
        
        for transaction in transactions {
            guard transaction.amount != nil else { continue }
            if let num = Double(transaction.amount!) {
                total += num
            }
           
        }
        
        return total
    }
    
    
    // MARK: - Core Data functions
    func fetchTransactions(tableView: UITableView) {
        
        do {
            self.transactions = try context.fetch(Transaction.fetchRequest())
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        catch {
            //TODO: Error handler
        }
    }
    
    private func saveTransactions(amount: String, date: String, tableView: UITableView) {
        let transaction = Transaction(context: self.context)
        transaction.amount = amount
        transaction.date = date
        
        do {
            try self.context.save()
        }
        catch {
            //TODO: Error handler
        }
        
        fetchTransactions(tableView: tableView)
    }
    
    private func deleteTransaction(transactionID: Int, tableView: UITableView) {
        
        self.context.delete(transactions[transactionID])
        
        do {
            try self.context.save()
        }
        catch {
            //TODO: Error handler
        }
        
        fetchTransactions(tableView: tableView)
    }
    
    func clearTransactions(tableView: UITableView) {
        
        for transaction in transactions {
            self.context.delete(transaction)
        }
        
        do {
            try self.context.save()
        }
        catch {
            //TODO: Error handler
        }
        
        fetchTransactions(tableView: tableView)
    }
    
}
