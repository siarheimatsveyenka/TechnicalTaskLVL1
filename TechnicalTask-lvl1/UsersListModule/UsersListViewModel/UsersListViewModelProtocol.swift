//
//  UsersListViewModelProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import Combine

protocol UsersListViewModelProtocol {
    var displayData: [UsersListDiplayModel] { get }
    var anyLoaderIsActivePublisher: AnyPublisher<Bool, Never> { get }
    var anyDeleteButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var anyAddButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    
    func readyToDisplay()
    func deleteButtonTapped()
    func addButtonTapped()
}
