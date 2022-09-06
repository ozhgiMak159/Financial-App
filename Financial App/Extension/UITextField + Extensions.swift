//
//  UITextField + Extensions.swift
//  Financial App
//
//  Created by Maksim  on 08.08.2022.
//

import UIKit

extension UITextField {
  
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar: UIToolbar = UIToolbar.init(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let item = [flexSpace, doneBarButtonItem]
        doneToolBar.items = item
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    
    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
    
}
