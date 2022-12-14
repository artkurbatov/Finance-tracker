//
//  TransactionViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 14.12.2022.
//

import UIKit

class TransactionViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let addButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureButton()
        
    }
    
    
    private func configureButton() {
        
        view.addSubview(addButton)
        
        addButton.configuration = .tinted()
        addButton.configuration?.title = "Add"
        addButton.configuration?.cornerStyle = .capsule
        addButton.configuration?.baseBackgroundColor = .systemBlue
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
