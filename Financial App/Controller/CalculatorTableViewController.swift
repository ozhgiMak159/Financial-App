//
//  CalculatorTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 06.08.2022.
//

import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    
    
    @IBOutlet weak var dateSlider: UISlider!
    
    
    var asset: Asset?
    
    @Published private var initialDateOfInvestmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveraging: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let calculator = Calculator()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialInvestmentAmountTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextFields()
        setupDateSlider()
        observerForm()
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
    
    private func setupDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    private func observerForm() {
        $initialDateOfInvestmentIndex.sink { [weak self] index in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.dateFormatter {
                self?.initialDateOfInvestment.text = dateString
            }
            
        }.store(in: &subscribers)
        
        notificationTextField()
        publisherElement()
    }
    
    private func notificationTextField() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField)
            .compactMap({
                ($0.object as? UITextField)?.text
            }).sink { [weak self] text in
                self?.initialInvestmentAmount = Int(text) ?? 0
            }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDollarCostAveragingTextField)
            .compactMap { notification -> String? in
                var text: String?
                if let textField = notification.object as? UITextField {
                    text = textField.text
                }
                return text
            }.sink { [weak self] (text) in
                self?.monthlyDollarCostAveraging = Int(text) ?? 0
            }.store(in: &subscribers)
    }
    
    private func publisherElement() {
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDollarCostAveraging, $initialDateOfInvestmentIndex)
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveraging, initialDateOfInvestmentIndex)  in
                guard let initialInvestmentAmount = initialInvestmentAmount,
                        let monthlyDollarCostAveraging = monthlyDollarCostAveraging,
                        let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex,
                        let asset = self?.asset else {
                            self?.resetViews()
                            return
                        }
                
                let result = self?.calculator.calculate(asset: asset, initialInvestmentAmount: initialInvestmentAmount.doubleValue,
                                                        monthlyDollarCostAveragingAmount: monthlyDollarCostAveraging.doubleValue,
                                                        initialDateInvestmentIndex: initialDateOfInvestmentIndex)
                
                let isProfitable = (result?.isProfitable == true)
                let gainSymbol = isProfitable ? "+" : ""
                
                self?.currentValueLabel.textColor = isProfitable ? .systemGreen : .systemRed
                self?.currentValueLabel.text = result?.currentValue.currencyFormat
                
                self?.investmentAmountLabel.text = result?.investmentAmount.currencyFormat
                self?.gainLabel.text = result?.gain.toCurrencyFormat(hasDollarSymbol: false, hasDecimalPlaces: false).prefix(withText: gainSymbol)
                
                self?.yieldLabel.text = result?.yield.percentageFormat.prefix(withText: gainSymbol).addBrackets()
                self?.yieldLabel.textColor = isProfitable ? .systemGreen : .systemRed
                
                self?.annualReturnLabel.text = result?.annualReturn.percentageFormat
                self?.annualReturnLabel.textColor = isProfitable ? .systemGreen : .systemRed
            }
        
        .store(in: &subscribers)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
              let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted  else { return }
        
        dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
        dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
        
        dateSelectionTableViewController.didSelectDate = { [weak self] index in
            self?.handleDateSelection(at: index)
        }
        
    }
    
    private func handleDateSelection(at index: Int) {
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
        
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDateOfInvestmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.dateFormatter
            initialDateOfInvestment.text = dateString
        }
    }
    
    private func resetViews() {
        currentValueLabel.text = "0.00"
        investmentAmountLabel.text = "0.00"
        gainLabel.text = "-"
        yieldLabel.text = "-"
        annualReturnLabel.text = "-"
    }
    
    
    @IBAction func dateSliderAction(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showInitialSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        
        return true
    }
}
