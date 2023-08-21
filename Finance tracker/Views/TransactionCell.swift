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
    private let commentLabel = UILabel()
    
    func configureCell(transactionToDisplay: Transaction) {
        let day = transactionToDisplay.day
        let month = transactionToDisplay.month
        let year = transactionToDisplay.year
        
        let date = "\(day)/\(month)/\(year)"
        configureAmountLabel(amount: transactionToDisplay.amount)
        configureCommentLabel(comment: transactionToDisplay.comment)
        configureDate(date: date)
    }
    
    private func configureAmountLabel(amount: Double) {
        contentView.addSubview(transactionAmount)
        
        transactionAmount.text = "\(amount) \(AppSettings.currency)"
        transactionAmount.textColor = amount < 0 ? .systemRed : .systemGreen
        
        transactionAmount.translatesAutoresizingMaskIntoConstraints = false
        
        transactionAmount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        transactionAmount.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        transactionAmount.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func configureCommentLabel(comment: String) {
        contentView.addSubview(commentLabel)
        
        commentLabel.text = comment
        commentLabel.textColor = .systemGray2
        commentLabel.numberOfLines = 2
        commentLabel.font = .preferredFont(forTextStyle: .footnote)
        
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        commentLabel.topAnchor.constraint(equalTo: transactionAmount.bottomAnchor, constant: 1).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    }
    
    private func configureDate(date: String) {
        contentView.addSubview(transactionDate)
        
        transactionDate.text = date
        transactionDate.textAlignment = .right
        
        transactionDate.translatesAutoresizingMaskIntoConstraints = false
        
        transactionDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        transactionDate.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7).isActive = true
        transactionDate.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
    }
}
