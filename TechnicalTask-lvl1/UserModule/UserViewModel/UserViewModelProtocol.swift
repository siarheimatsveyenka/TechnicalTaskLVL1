//
//  UserViewModelProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine

protocol UserViewModelProtocol {
    var anySaveUserInfoButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var userInfoClosure: ((UsersListDiplayModel) -> ())? { get }
    
    func saveUserInfoButtonTapped()
    func submitUserInfo(_ userInfo: UsersListDiplayModel)
    func userNameUpdated(_ userName: String)
    func userEmailUpdated(_ userEmail: String)
    func cityNameUpdated(_ cityName: String)
    func streetNameUpdated(_ streetName: String)
}
