//
//  InternetCheckingService.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 26.11.24.
//

import Foundation
import Network
import Combine

final class InternetCheckingService: InternetCheckable {
    
    // MARK: - Parameters
    
    private let monitor = NWPathMonitor()
    
    private let isInternetActivePublisher = PassthroughSubject<Bool, Never>()
    var anyIsInternetActivePublisher: AnyPublisher<Bool, Never> {
        self.isInternetActivePublisher.eraseToAnyPublisher()
    }
    
    // MARK: - Checker
    
    func startChecking() {
        self.monitor.start(queue: .global())
        
        self.monitor.pathUpdateHandler = { path in            
            switch path.status {
            case .satisfied:
                self.isInternetActivePublisher.send(true)
            default:
                self.isInternetActivePublisher.send(false)
            }
        }
    }
}
