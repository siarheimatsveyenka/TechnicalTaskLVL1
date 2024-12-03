//
//  UserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import UIKit
import Combine

final class UserViewModel: UserViewModelProtocol {
    
    // MARK: - Parameters
    
    private let currentEmailsArray: [String]
    private var userInfo = UsersListDisplayModel(
        username: String(),
        email: String(),
        city: String(),
        street: String(),
        isAnimationNeeded: true
    )
    
    var userInfoClosure: ((UsersListDisplayModel) -> ())?
    
    // MARK: - Initialization
    
    init(currentEmailsArray: [String]) {
        self.currentEmailsArray = currentEmailsArray
    }
    
    // MARK: - Parameters
    
    private let saveUserInfoButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anySaveUserInfoButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.saveUserInfoButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    private let emailTextFieldColorPublisher = PassthroughSubject<UIColor, Never>()
    var anyEmailTextFieldColorPublisher: AnyPublisher<UIColor, Never> {
        self.emailTextFieldColorPublisher.eraseToAnyPublisher()
    }
    
    private let userExistPublisher = PassthroughSubject<Void, Never>()
    var anyUserExistPublisher: AnyPublisher<Void, Never> {
        self.userExistPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Events
    
    func saveUserInfoButtonTapped() {
        guard self.isInputedDataValid(self.userInfo) else { return }
        if self.currentEmailsArray.contains(self.userInfo.email) {
            self.userExistPublisher.send()
        } else {
            self.userInfoClosure?(self.userInfo)
            self.saveUserInfoButtonTappedPublisher.send()
        }
    }
    
    func userNameUpdated(_ userName: String) {
        self.userInfo.username = userName
    }
    
    func userEmailUpdated(_ userEmail: String) {
        self.emailTextFieldColorPublisher.send(
            userEmail.isValidEmailComplex()
            ? .black
            : .red
        )
        
        self.userInfo.email = userEmail
    }
    
    func cityNameUpdated(_ cityName: String) {
        self.userInfo.city = cityName
    }
    
    func streetNameUpdated(_ streetName: String) {
        self.userInfo.street = streetName
    }
    
    func isInputedDataValid(_ userInfo: UsersListDisplayModel) -> Bool {
        userInfo.email.isValidEmailComplex() &&
        !userInfo.username.isEmpty &&
        !userInfo.city.isEmpty &&
        !userInfo.street.isEmpty
    }
}
