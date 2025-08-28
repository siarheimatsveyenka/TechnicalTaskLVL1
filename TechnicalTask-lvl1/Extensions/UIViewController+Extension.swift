//
//  UIViewController+Extension.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 28.11.24.
//

import UIKit

extension UIViewController {
    func showError(alertTitle: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(
            title: alertTitle,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
                title: buttonTitle,
                style: .cancel,
                handler: nil
            )
        )
        
        DispatchQueue.main.async {
            self.present(
                alert,
                animated: true,
                completion: nil
            )
        }
    }
}
