//
//  TableViewFooterView.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 16.12.2022.
//

import Foundation
import UIKit

class CustomFooter: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            //configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
