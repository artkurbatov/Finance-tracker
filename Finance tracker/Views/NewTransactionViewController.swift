//
//  NewTransactionViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 17.08.2023.
//

import UIKit

class NewTransactionViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "New Transaction"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
        return textView
    }()
    
    private lazy var savingsButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "Savings"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var spandingsButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.baseForegroundColor = .white
        button.configuration?.title = "Spandigs"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setConstraints()
    }
    
    private func setConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(amountTextField)
        view.addSubview(commentTextView)
        view.addSubview(savingsButton)
        view.addSubview(spandingsButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            amountTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            commentTextView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10),
            commentTextView.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            commentTextView.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            commentTextView.heightAnchor.constraint(equalToConstant: 70),
            
            spandingsButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 10),
            spandingsButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
            spandingsButton.heightAnchor.constraint(equalToConstant: 40),
            spandingsButton.widthAnchor.constraint(equalToConstant: 120),
            
            savingsButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 10),
            savingsButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 15),
            savingsButton.heightAnchor.constraint(equalToConstant: 40),
            savingsButton.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
}
