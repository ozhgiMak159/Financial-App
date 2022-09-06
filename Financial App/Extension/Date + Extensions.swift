//
//  Date + Extensions.swift
//  Financial App
//
//  Created by Maksim  on 08.08.2022.
//

import Foundation

extension Date {
    
    var dateFormatter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }

}
