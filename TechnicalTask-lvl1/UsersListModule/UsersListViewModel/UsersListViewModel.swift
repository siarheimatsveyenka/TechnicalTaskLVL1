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
    private let coreDataService: CoreDataServiceProtocol
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
    
    private let isShowingInternetErrorPublisher = PassthroughSubject<Bool, Never>()
    var anyIsShowingInternetErrorPublisher: AnyPublisher<Bool, Never> {
        self.isShowingInternetErrorPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    
    init(updatingUsersDataFacade: UpdatingUsersDataFacadeProtocol, coreDataService: CoreDataServiceProtocol) {
        self.updatingUsersDataFacade = updatingUsersDataFacade
        self.coreDataService = coreDataService
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
        
        self.updatingUsersDataFacade.anyConnectionErrorPublisher
            .sink { [weak self] isError in
                guard let self else { return }
                self.isShowingInternetErrorPublisher.send(isError)
            }
            .store(in: &self.cancellables)
        
        self.updatingUsersDataFacade.fetchUsersData()
    }
    
    func addButtonTapped() {
        self.addButtonTappedPublisher.send()
    }
    
    func pullToRefresh() {
        self.updatingUsersDataFacade.anyDisplayDataUpdatedPublisherPublisher
            .sink { [weak self] data in
                guard let self else { return }
                self.displayData = data.sorted { $0.username < $1.username }
                self.displayDataUpdatedPublisher.send()
            }
            .store(in: &self.cancellables)
        
        self.updatingUsersDataFacade.fetchUsersData()
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
    
    func userDeletingActivatedWithIndex(_ index: Int) {
        self.updatingUsersDataFacade.deleteUser(self.displayData[index])
    }
}

// MARK: - Actions and handlers

private extension UsersListViewModel {
    func startLoaderAnimating() {
        self.loaderIsActivePublisher.send(true)
    }
}
