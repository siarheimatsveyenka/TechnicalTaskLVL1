//
//  ManuallyInputedDataChekerProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation

protocol ManuallyInputedDataChekerProtocol {
    func isInputedDataValid(_ userInfo: UsersListDiplayModel) -> Bool
    func isValidEmailComplex(_ email: String) -> Bool
}
