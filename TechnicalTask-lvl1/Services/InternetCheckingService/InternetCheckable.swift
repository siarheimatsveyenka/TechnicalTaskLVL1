//
//  InternetCheckable.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Combine

protocol InternetCheckable {
    var anyIsInternetActivePublisher: AnyPublisher<Bool, Never> { get }
    
    func startChecking()
}
