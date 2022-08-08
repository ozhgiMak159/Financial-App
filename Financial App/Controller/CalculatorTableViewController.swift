//
//  CalculatorTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 06.08.2022.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    
    
    
    var asset: Asset?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextFields()
    }

    private func setupView() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        currencyLabels.forEach { label in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
    }
    
    //showInitialSelection
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
              let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted  else { return }
        
        dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
        dateSelectionTableViewController.didSelectDate = { index in
            print("\(index)")
            
        }
    }
    
    private func handleDateSelection() {
        
    }
    
    
    
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showInitialSelection", sender: asset?.timeSeriesMonthlyAdjusted)
        }
        return false
    }
}
