//
//  FinanceModel.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 14.12.2022.
//

import UIKit
import Foundation


protocol FinaceModelDelegate {
    
}


class FinanceModel {
    
    #warning("")
    
    static let identifier = "transactionCell"
    
    var transactions = [Transaction]()
    
    func createTestTransaction(tableView: UITableView) {
        
        self.saveTransactions(amount: 20.0, day: "11", month: "12", year: "22", tableView: tableView)
        self.saveTransactions(amount: -20.0, day: "7", month: "10", year: "22", tableView: tableView)
        self.saveTransactions(amount: 11.0, day: "3", month: "6", year: "20", tableView: tableView)
    }
    
    
    func createAlert(tableView: UITableView) -> UIAlertController {
        
        let alert = UIAlertController(title: "New transaction", message: "", preferredStyle: .alert)
        
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if alert.textFields?[0] != nil && alert.textFields?[0].text != nil {
                let amount = alert.textFields![0].text!
                if let number = Double(amount) {
//                    if !amount.contains(".") {
//                        amount += ".0"
//                    }
                    // TODO: Change symbol for
                    //amount += " $"
                    let dateString = self.getDateString()
                    self.saveTransactions(amount: number.round(to: 2), day: dateString.0, month: dateString.1, year: dateString.2, tableView: tableView)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func getDateString() -> (String, String, String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        let date = Date()
        let dateString = formatter.string(from: date)
        let compontents = dateString.split(separator: "/")
        
        let day = String(compontents[0])
        let month = String(compontents[1])
        let year = String(compontents[2])
        
        return (day, month, year)
    }
    
    
    func calculateTotal(transactions: [Transaction]) -> Double {
        
        var total = 0.0
        
        for transaction in transactions {
            total += transaction.amount
        }
        
        return total.round(to: 2)
    }
    
    
    // MARK: - Core Data functions
    func fetchTransactions(tableView: UITableView) {
        
       
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
    }
    
    func saveTransactions(amount: Double, day: String, month: String, year: String, tableView: UITableView) {
       
        transactions.append(Transaction(amount: amount, day: day, month: month, year: year))
        
        fetchTransactions(tableView: tableView)
    }
    
    func deleteTransaction(transactionID: Int, tableView: UITableView) {
        
        
        fetchTransactions(tableView: tableView)
    }
    
    func clearTransactions(tableView: UITableView) {
        
        transactions.removeAll()
        
        fetchTransactions(tableView: tableView)
    }
    
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
