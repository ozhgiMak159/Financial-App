//
//  UIAnimatable.swift
//  Financial App
//
//  Created by Maksim  on 04.08.2022.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension UIAnimatable {
    func showLoadingAnimation() {
        DispatchQueue.main.async { [unowned self] in
            let isShown = view.subviews.filter { $0 is MBProgressHUD }.isEmpty == false
            if !isShown {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    

}
