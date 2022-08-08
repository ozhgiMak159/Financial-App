//
//  DateSelectionTableViewController.swift
//  Financial App
//
//  Created by Maksim  on 08.08.2022.
//

import UIKit


class DateSelectionTableViewController: UITableViewController {
    
    
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    private var mountInfos: [MonthInfo] = []
    
    //????
    var didSelectDate: ((Int) -> Void)?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfos()
        setupNavigation()
    }
    
    private func setupMonthInfos() {
        mountInfos = timeSeriesMonthlyAdjusted?.getMonthInfos() ?? []
    }
    
    private func setupNavigation() {
        title = "Select date"
    }
}

extension DateSelectionTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mountInfos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DateSelectionTableViewCell
        let index = indexPath.row
        let monthInfo = mountInfos[index]
        let isSelected = index == selectedIndex
        cell.configure(with: monthInfo, index: index, isSelectedIndex: isSelected)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true) // ????? Выделения строки
    }
    
    
}
