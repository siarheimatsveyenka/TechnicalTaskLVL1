//
//  ManuallyInputedDataCheker.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation

final class ManuallyInputedDataCheker: ManuallyInputedDataChekerProtocol {
    
    // MARK: -  Methods
    
    func isInputedDataValid(_ userInfo: UsersListDiplayModel) -> Bool {
        if self.isValidEmailComplex(userInfo.email) &&
            !userInfo.username.isEmpty &&
            !userInfo.city.isEmpty &&
            !userInfo.street.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmailComplex(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
