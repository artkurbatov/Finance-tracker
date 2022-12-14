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
    
    private let financeModel = FinanceModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureButton()
        configureTextField()
        
    }
    
    
    private func configureButton() {
        
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
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
    
    @objc func addButtonAction() {
        print(textField.text ?? "No text")
        dismiss(animated: true)
    }
    
    private func configureTextField() {
        
        view.addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
       
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
