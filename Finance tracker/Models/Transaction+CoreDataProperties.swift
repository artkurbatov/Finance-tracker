//
//  Transaction+CoreDataProperties.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 14.12.2022.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: String?
    @NSManaged public var date: String?

}

extension Transaction : Identifiable {

}
