//
//  TransactionCell.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 14.12.2022.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    private let transactionAmount = UILabel()
    private let transactionDate = UILabel()
    
    func configureCell(transactionToDisplay: Transaction) {
        if let day = transactionToDisplay.day, let month = transactionToDisplay.month, let year = transactionToDisplay.year {
            
            let date = "\(day)/\(month)/\(year)"
            configureAmountLabel(amount: transactionToDisplay.amount)
            configureDate(date: date)
        }
        
    }
    
    private func configureAmountLabel(amount: Double) {
        
        addSubview(transactionAmount)
        
        transactionAmount.text = "\(amount) $"
        transactionAmount.textColor = amount < 0 ? .systemRed : .systemGreen
        
        transactionAmount.translatesAutoresizingMaskIntoConstraints = false
        
        transactionAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        transactionAmount.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        transactionAmount.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func configureDate(date: String) {
        
        addSubview(transactionDate)
        
        transactionDate.text = date
        transactionDate.textAlignment = .right
        
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        
        transactionDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        transactionDate.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        transactionDate.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func configureCategory(categoty: String) {
        
    }
    
}
