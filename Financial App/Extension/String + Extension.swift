//
//  String + Extension.swift
//  Financial App
//
//  Created by Maksim  on 06.08.2022.
//

import UIKit

extension String {
    
    func addBrackets() -> String {
        return "(\(self))"
    }
    
    func prefix(withText text: String) -> String {
        return text + self
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    
    
    
}
