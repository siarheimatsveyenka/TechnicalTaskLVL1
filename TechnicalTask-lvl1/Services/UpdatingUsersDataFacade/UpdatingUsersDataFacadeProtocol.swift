//
//  UpdatingUsersDataFacadeProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine

protocol UpdatingUsersDataFacadeProtocol {
    var anyDisplayDataUpdatedPublisherPublisher: AnyPublisher<[UsersListDiplayModel], Never> { get }

    func fetchUsersData()
    func saveUsersData(_ userInfo: UsersListDiplayModel)
    func deleteUser(_ user: UsersListDiplayModel)
}
