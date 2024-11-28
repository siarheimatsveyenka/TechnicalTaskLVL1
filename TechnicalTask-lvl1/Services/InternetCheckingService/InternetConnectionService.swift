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
    
    private var perviousConnectionIsActive: Bool = false
    
    // MARK: - Checker
    
    func startChecking() {
        self.monitor.start(queue: .global(qos: .background))
        
        if !perviousConnectionIsActive {
            self.monitor.pathUpdateHandler = { [weak self] path in
                guard let self else { return }
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
                    switch path.status {
                    case .satisfied:
                        self.isInternetActivePublisher.send(true)
                        self.perviousConnectionIsActive = true
                    default:
                        self.isInternetActivePublisher.send(false)
                        self.perviousConnectionIsActive = false
                    }
                }
            }
        } else {
            self.isInternetActivePublisher.send(true)
        }
    }
}
