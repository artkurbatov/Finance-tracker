//
//  TabBarViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 13.12.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let financeVC = FinanceViewController()
        financeVC.tabBarItem.image = UIImage(systemName: "dollarsign.circle")
        financeVC.tabBarItem.title = "Finance"
        
        setViewControllers([financeVC], animated: true)
    }
}
