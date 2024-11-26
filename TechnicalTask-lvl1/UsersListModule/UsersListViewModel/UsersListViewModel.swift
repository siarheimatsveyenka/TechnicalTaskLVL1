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
    
    private let updatingUsersDataFacade: UpdatingUsersDataFacadeProtocol
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
    
    private let displayDataUpdatedPublisher = PassthroughSubject<Void, Never>()
    var anyDisplayDataUpdatedPublisherPublisher: AnyPublisher<Void, Never> {
        self.displayDataUpdatedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(updatingUsersDataFacade: UpdatingUsersDataFacadeProtocol) {
        self.updatingUsersDataFacade = updatingUsersDataFacade
    }
    
    // MARK: - Events
    
    func readyToDisplay() {
        self.startLoaderAnimating()
    }
    
    func addButtonTapped() {
        self.addButtonTappedPublisher.send()
    }
    
    func handleAddedManuallyUserInfo(_ userInfo: UsersListDiplayModel) {
        guard !self.displayData.contains(where: { $0.email == userInfo.email } ) else { return }
        self.displayData.append(userInfo)
        self.displayDataUpdatedPublisher.send()
    }
}

// MARK: - Actions and handlers

private extension UsersListViewModel {
    func startLoaderAnimating() {
        self.loaderIsActivePublisher.send(true)
    }
}
