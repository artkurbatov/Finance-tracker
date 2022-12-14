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
    
    static let identifier = "transactionCell"
    
    var transactions = [Transaction]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createAlert(tableView: UITableView) -> UIAlertController {
        
        let alert = UIAlertController(title: "Add transaction", message: "", preferredStyle: .alert)
        
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if alert.textFields?[0] != nil && alert.textFields?[0].text != nil {
                if let _ = Int(alert.textFields![0].text!) {
                    let dateString = self.getDateString()
                    self.saveTransactions(amount: alert.textFields![0].text!, date: dateString, tableView: tableView)
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
    
}
