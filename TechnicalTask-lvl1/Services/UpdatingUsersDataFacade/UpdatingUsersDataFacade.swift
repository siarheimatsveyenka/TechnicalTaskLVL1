//
//  UpdatingUsersDataFacade.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine
import CoreData

final class UpdatingUsersDataFacade: UpdatingUsersDataFacadeProtocol {
    
    // MARK: - Services
    
    private let coreDataService: CoreDataServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let internetChecker: InternetCheckable
    private var cancellables: Set<AnyCancellable> = []
    
    private let displayDataUpdatedPublisher = PassthroughSubject<[UsersListDiplayModel], Never>()
    var anyDisplayDataUpdatedPublisherPublisher: AnyPublisher<[UsersListDiplayModel], Never> {
        self.displayDataUpdatedPublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization

    init(coreDataService: CoreDataServiceProtocol, networkService: NetworkServiceProtocol, internetChecker: InternetCheckable) {
        self.coreDataService = coreDataService
        self.networkService = networkService
        self.internetChecker = internetChecker
    }
    
    // MARK: - Methods
    
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
    
    func fetchUsersData() {
        self.internetChecker.anyIsInternetActivePublisher
            .receive(on: DispatchQueue.global())
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.getUsersDataAccordingConnection(isConnected)
            }
            .store(in: &self.cancellables)
        
        self.internetChecker.startChecking()
        
        
    }
    
    func getUsersDataAccordingConnection(_ isConnected: Bool) {
        var uploadedData = [UsersListDiplayModel]()
        
        if isConnected {
            Task {
                do {
                    let responseData: [UserModel] = try await self.networkService.requestData(toEndPoint: ApiUrls.users, httpMethod: .get)
                    let usersData = try await self.coreDataService.fetchUsers()
                    uploadedData.append(contentsOf: self.prepareUserDisplayData(from: usersData))
                    uploadedData.append(contentsOf: self.updateResponseData(responseData))
                    
                    self.displayDataUpdatedPublisher.send(uploadedData)
                }
                
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func prepareUserDisplayData(from coreDataData: [NSManagedObject]) -> [UsersListDiplayModel] {
        var result = [UsersListDiplayModel]()
        
        coreDataData.forEach { managedObject in
            result.append(
                UsersListDiplayModel(
                    username: managedObject.value(forKey: CoreDataStrings.attributeUserName) as? String ?? String(),
                    email: managedObject.value(forKey: CoreDataStrings.attributeEmail) as? String ?? String(),
                    city: managedObject.value(forKey: CoreDataStrings.attributeCity) as? String ?? String(),
                    street: managedObject.value(forKey: CoreDataStrings.attributeStreet) as? String ?? String(),
                    isAnimatingNeeded: true
                )
            )
        }
        
        return result
    }
    
    func updateResponseData(_ responseData: [UserModel]) -> [UsersListDiplayModel] {
        var result = [UsersListDiplayModel]()
        
        responseData.forEach {
            result.append(
                UsersListDiplayModel(
                    username: $0.username,
                    email: $0.email,
                    city: $0.address.city,
                    street: $0.address.street,
                    isAnimatingNeeded: true
                )
            )
        }
        
        return result
    }
}
