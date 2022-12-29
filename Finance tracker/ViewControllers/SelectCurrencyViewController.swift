//
//  SelectCurrencyViewController.swift
//  Finance tracker
//
//  Created by Kurbatov Artem on 29.12.2022.
//

import UIKit

class SelectCurrencyViewController: UIViewController {
    
    private let titleLable = UILabel()
    private let currencyPicker = UIPickerView()
    private let okButton = UIButton()
    
    private let currencyList = ["Dollar $", "Euro €", "Sterling £", "Yen ¥", "Ruble ₽"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        configureTitle()
        configureButton()
        configureCurrencyPicker()
    }
    
    
    private func configureTitle() {
        
        view.addSubview(titleLable)
        
        titleLable.text = "Select your currency"
        
        titleLable.font = UIFont.preferredFont(forTextStyle: .title1)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureCurrencyPicker() {
        
        view.addSubview(currencyPicker)
        
        currencyPicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            currencyPicker.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            currencyPicker.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -10),
            currencyPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureButton() {
        
        view.addSubview(okButton)
        
        okButton.configuration = .filled()
        okButton.configuration?.cornerStyle = .capsule
        okButton.configuration?.title = "OK"
        okButton.configuration?.baseBackgroundColor = .systemBlue
        okButton.configuration?.baseForegroundColor = .white
        
        okButton.addTarget(self, action: #selector(selectCurrencyAction), for: .touchUpInside)
        
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            okButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func selectCurrencyAction() {
        
        let selectedRow = currencyPicker.selectedRow(inComponent: 0)
        
        print("\(currencyList[selectedRow].last!)")
        
        AppSettings.currency = "\(currencyList[selectedRow].last!)"
        
        //TODO: Update table view and button ImageView
        
        dismiss(animated: true)
    }
}

extension SelectCurrencyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyList[row]
    }
}
