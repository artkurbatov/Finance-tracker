//
//  Transaction.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 24.12.2022.
//

import Foundation

struct Transaction {
    
    let id = UUID()
    var amount: Double
    var day: String
    var month: String
    var year: String
}
