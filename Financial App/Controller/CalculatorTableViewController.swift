//
//  CalculatorTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 06.08.2022.
//

import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    // MARK: - @IBOutlet property
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
    
    // MARK: - Private & Public property
    var asset: Asset?
    
    @Published private var initialDateOfInvestmentIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveraging: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let calculator = Calculator()
    private let calculatorPresenter = CalculatorPresenter()
    
    // MARK: - Life Cycle Method
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            initialInvestmentAmountTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDateSlider()
        observerForm()
    }

    // MARK: - Private Method
    private func setupView() {
        navigationItem.title = asset?.searchResult.symbol
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        
        currencyLabels.forEach { label in
            label.text = asset?.searchResult.currency.addBrackets()
        }
        
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
            .sink { [weak self] (initialInvestmentAmount, monthlyDollarCostAveraging, initialDateOfInvestmentIndex) in
                guard let initialInvestmentAmount = initialInvestmentAmount, let monthlyDollarCostAveraging = monthlyDollarCostAveraging,
                        let initialDateOfInvestmentIndex = initialDateOfInvestmentIndex,
                        let asset = self?.asset else {
                            self?.resetViews()
                            return
                        }
                
                guard let this = self else { return }
                
                let result = this.calculator.calculate(
                    asset: asset, initialInvestmentAmount: initialInvestmentAmount.doubleValue,
                    monthlyDollarCostAveragingAmount: monthlyDollarCostAveraging.doubleValue,
                    initialDateInvestmentIndex: initialDateOfInvestmentIndex
                )
                
                let presentation = this.calculatorPresenter.getPresentation(result: result)
                
                this.currentValueLabel.textColor = presentation.currentValueLabelBackgroundColor
                this.currentValueLabel.text = presentation.currentValue
                this.investmentAmountLabel.text = presentation.investmentAmount
                this.gainLabel.text = presentation.gain
                this.yieldLabel.text = presentation.yield
                this.yieldLabel.textColor = presentation.yieldLabelTextColor
                this.annualReturnLabel.text = presentation.annualReturn
                this.annualReturnLabel.textColor = presentation.annualReturnLabelTextColor
            }
        
        .store(in: &subscribers)
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
        gainLabel.textColor = .black
        
        yieldLabel.text = "-"
        yieldLabel.textColor = .black
        
        annualReturnLabel.text = "-"
        annualReturnLabel.textColor = .black
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
              let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted  else { return }
        
        dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
        dateSelectionTableViewController.selectedIndex = initialDateOfInvestmentIndex
        
        dateSelectionTableViewController.didSelectDate = { [weak self] index in
            self?.handleDateSelection(at: index)
        }
    }
    
    // MARK: - @IBAction Method
    @IBAction func dateSliderAction(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
}

// MARK: - UITextFieldDelegate
extension CalculatorTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialDateOfInvestment {
            performSegue(withIdentifier: "showInitialSelection", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        
        return true
    }
}
