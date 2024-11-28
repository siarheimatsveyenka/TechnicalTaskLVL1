//
//  UIViewController+Extension.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 28.11.24.
//

import UIKit

extension UIViewController {
    func showError(message: String) {
        let alert = UIAlertController(
            title: "Warning",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
                title: "Ok",
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
