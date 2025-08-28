//
//  UpdatingUsersDataFacadeProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine

protocol UpdatingUsersDataFacadeProtocol {
    var anyDisplayDataUpdatedPublisher: AnyPublisher<[UsersListDisplayModel], Never> { get }
    var anyConnectionErrorPublisher: AnyPublisher<Bool, Never> { get }

    func fetchUsersData()
    func saveUsersData(_ userInfo: UsersListDisplayModel)
    func deleteUser(_ user: UsersListDisplayModel)
}
