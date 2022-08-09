//
//  DateSelectionTableViewCell.swift
//  Financial App
//
//  Created by Maksim  on 08.08.2022.
//

import UIKit


class DateSelectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    
    func configure(with monthInfo: MonthInfo, index: Int, isSelectedIndex: Bool) {
        monthLabel.text = monthInfo.date.dateFormatter
        
        accessoryType = isSelectedIndex
                        ? .checkmark
                        : .none
        
        
        // Подумать как сделать свитч и выписывать года и месяцы
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) months ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
        
     
        
        
    }
    
}
