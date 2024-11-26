//
//  UpdatingUsersDataFacade.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation

final class UpdatingUsersDataFacade: UpdatingUsersDataFacadeProtocol {
    
    // MARK: - Services
    
    private let coreDataService: CoreDataServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let internetChecker: InternetCheckable
    
    // MARK: - Initialization

    init(coreDataService: CoreDataServiceProtocol, networkService: NetworkServiceProtocol, internetChecker: InternetCheckable) {
        self.coreDataService = coreDataService
        self.networkService = networkService
        self.internetChecker = internetChecker
    }
    
    func saveUsersData(_ userInfo: UsersListDiplayModel) {
        Task {
            do {
                try await self.coreDataService.saveUser(
                    UserModel(
                        username: userInfo.username,
                        email: userInfo.email,
                        address: Address(
                            city: userInfo.city,
                            street: userInfo.street
                        )
                    )
                )
            }
            
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUsersData() -> [UsersListDiplayModel] {
        return [UsersListDiplayModel(username: "", email: "", city: "", street: "", isAnimatingNeeded: true)]
    }
}
