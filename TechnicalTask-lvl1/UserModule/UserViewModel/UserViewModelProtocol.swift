//
//  UserViewModelProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import UIKit
import Combine

protocol UserViewModelProtocol {
    var anySaveUserInfoButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var anyEmailTextFieldColorPublisher: AnyPublisher<UIColor, Never> { get }
    var anyUserExistPublisher: AnyPublisher<Void, Never> { get }
    var userInfoClosure: ((UsersListDisplayModel) -> ())? { get }
    
    func saveUserInfoButtonTapped()
    func userNameUpdated(_ userName: String)
    func userEmailUpdated(_ userEmail: String)
    func cityNameUpdated(_ cityName: String)
    func streetNameUpdated(_ streetName: String)
}
