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
    
    private let inputedDataCheker: ManuallyInputedDataChekerProtocol
    private let currentEmailsArray: [String]
    private var userInfo = UsersListDiplayModel(
        username: String(),
        email: String(),
        city: String(),
        street: String(),
        isAnimatingNeeded: true
    )
    
    var userInfoClosure: ((UsersListDiplayModel) -> ())?
    
    // MARK: - Initialization
    
    init(inputedDataCheker: ManuallyInputedDataChekerProtocol, currentEmailsArray: [String]) {
        self.inputedDataCheker = inputedDataCheker
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
        guard self.inputedDataCheker.isInputedDataValid(self.userInfo) else { return }
        guard !self.currentEmailsArray.contains(self.userInfo.email) else {
            self.userExistPublisher.send()
            return
        }
        
        self.userInfoClosure?(self.userInfo)
        self.saveUserInfoButtonTappedPublisher.send()
    }
    
    func userNameUpdated(_ userName: String) {
        self.userInfo.username = userName
    }
    
    func userEmailUpdated(_ userEmail: String) {
        self.inputedDataCheker.isValidEmailComplex(userEmail)
        ? self.emailTextFieldColorPublisher.send(.black)
        : self.emailTextFieldColorPublisher.send(.red)
        
        self.userInfo.email = userEmail
    }
    
    func cityNameUpdated(_ cityName: String) {
        self.userInfo.city = cityName
    }
    
    func streetNameUpdated(_ streetName: String) {
        self.userInfo.street = streetName
    }
}
