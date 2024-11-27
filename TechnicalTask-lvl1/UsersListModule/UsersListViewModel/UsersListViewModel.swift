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
    private var cancellables: Set<AnyCancellable> = []

    var displayData = [UsersListDiplayModel]()
    
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
        
        
        self.updatingUsersDataFacade.anyDisplayDataUpdatedPublisherPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.displayData = data.sorted { $0.username < $1.username }
                self.displayDataUpdatedPublisher.send()
            }
            .store(in: &self.cancellables)
        
        self.updatingUsersDataFacade.fetchUsersData()
    }
    
    func addButtonTapped() {
        self.addButtonTappedPublisher.send()
    }
    
    func handleAddedManuallyUserInfo(_ userInfo: UsersListDiplayModel) {
        guard !self.displayData.contains(where: { $0.email == userInfo.email } ) else { return }
        self.displayData.append(userInfo)
        self.displayData.sort { $0.username < $1.username }
        self.displayDataUpdatedPublisher.send()
        self.updatingUsersDataFacade.saveUsersData(userInfo)
    }
    
    func prepareEmailsForChecking() -> [String] {
        self.displayData.map { $0.email }
    }
}

// MARK: - Actions and handlers

private extension UsersListViewModel {
    func startLoaderAnimating() {
        self.loaderIsActivePublisher.send(true)
    }
}
