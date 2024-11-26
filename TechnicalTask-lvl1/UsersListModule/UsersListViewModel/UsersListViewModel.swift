//
//  UsersListViewModel.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import Combine

final class UsersListViewModel: UsersListViewModelProtocol {
    
    // MARK: - Parameters
    
    var displayData = [
        UsersListDiplayModel(
            username: "Delphine",
            email: "Chaim_McDermott@dana.io",
            city: "Bartholomebury",
            street: "Dayna Park",
            isAnimatingNeeded: false
        )
    ]
    
    private let loaderIsActivePublisher = PassthroughSubject<Bool, Never>()
    var anyLoaderIsActivePublisher: AnyPublisher<Bool, Never> {
        self.loaderIsActivePublisher.eraseToAnyPublisher()
    }
    
    private let addButtonTappedPublisher = PassthroughSubject<Void, Never>()
    var anyAddButtonTappedPublisher: AnyPublisher<Void, Never> {
        self.addButtonTappedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Events
    
    func readyToDisplay() {
        self.startLoaderAnimating()
    }
    
    func addButtonTapped() {
        self.addButtonTappedPublisher.send()
    }
    
    func handleAddedManuallyUserInfo(_ userInfo: UsersListDiplayModel) {
        dump(userInfo)
    }
}

// MARK: - Actions and handlers

private extension UsersListViewModel {
    func startLoaderAnimating() {
        self.loaderIsActivePublisher.send(true)
    }
}
