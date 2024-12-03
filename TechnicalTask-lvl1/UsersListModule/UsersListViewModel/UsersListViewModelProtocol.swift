//
//  UsersListViewModelProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation
import Combine

protocol UsersListViewModelProtocol {
    var displayData: [UsersListDisplayModel] { get set }
    var anyLoaderIsActivePublisher: AnyPublisher<Bool, Never> { get }
    var anyAddButtonTappedPublisher: AnyPublisher<Void, Never> { get }
    var anyDisplayDataUpdatedPublisher: AnyPublisher<Void, Never> { get }
    var anyIsShowingInternetErrorPublisher: AnyPublisher<Bool, Never> { get }
    
    func startDataLoading()
    func addButtonTapped()
    func handleAddedManuallyUserInfo(_ userInfo: UsersListDisplayModel)
    func prepareEmailsForChecking() -> [String]
    func pullToRefresh()
    func userDeletingActivatedWithIndex(_ index: Int)
}
