//
//  Transaction+CoreDataProperties.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 21.12.2022.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var day: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?

}

extension Transaction : Identifiable {

}
