//
//  UITextField+Extension.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import UIKit
import Combine

extension UITextField {
    func publisher() -> AnyPublisher<UITextField, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { $0.object as? UITextField ?? UITextField() }
            .eraseToAnyPublisher()
    }
}
