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
        accessoryType = isSelectedIndex ? .checkmark : .none
        
        switch index {
        case 1:
            monthsAgoLabel.text = "1 month ago"
        case _ where index > 1:
            monthsAgoLabel.text = "\(index) months ago"
        default:
            monthsAgoLabel.text = "Just invested"
        }
    }
    
}
