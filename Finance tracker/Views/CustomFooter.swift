//
//  TableViewFooterView.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 16.12.2022.
//

import Foundation
import UIKit

class CustomFooter: UITableViewHeaderFooterView {
    
    private let total = UILabel()
    let amount = UILabel()
    
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(summ: String) {
        
        contentView.addSubview(total)
        contentView.addSubview(amount)
        
        total.translatesAutoresizingMaskIntoConstraints = false
        amount.translatesAutoresizingMaskIntoConstraints = false
        
        total.text = "Total: "
        total.font = UIFont.boldSystemFont(ofSize: 20)
        
        amount.text = summ
        amount.font = UIFont.boldSystemFont(ofSize: 20)
        amount.textAlignment = .right
        
        let split = summ.split(separator: " ")
        
        var color: UIColor = .lightGray
        
        if let number = Double(split[0]) {
            if number > 0 { color = .systemGreen }
            else if number < 0 { color = .systemRed }
        }
        
        amount.textColor = color
        
        NSLayoutConstraint.activate([
            total.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            total.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            amount.leadingAnchor.constraint(equalTo: total.trailingAnchor),
            amount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
