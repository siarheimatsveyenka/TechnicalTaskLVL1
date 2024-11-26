//
//  UserViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine

final class UserViewModel: UserViewModelProtocol {
    
    var userInfoClosure: ((UsersListDiplayModel) -> ())?
    
    // MARK: - Parameters
    
    private let saveUserInfoButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anySaveUserInfoButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.saveUserInfoButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Events
    
    func saveUserInfoButtonTapped() {
        self.saveUserInfoButtonTappedPublisher.send()
    }
    
    func submitUserInfo(_ userInfo: UsersListDiplayModel) {
        self.userInfoClosure?(userInfo)
    }
    
    func userNameUpdated(_ userName: String) {
        
    }
    
    func userEmailUpdated(_ userEmail: String) {
        
    }
    
    func cityNameUpdated(_ cityName: String) {
        
    }
    
    func streetNameUpdated(_ streetName: String) {
        
    }
}
