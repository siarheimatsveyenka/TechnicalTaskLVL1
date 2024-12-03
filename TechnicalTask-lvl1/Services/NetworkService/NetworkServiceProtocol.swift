//
//  NetworkServiceProtocol.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation

protocol NetworkServiceProtocol {
    func requestData<T: Codable>(toEndPoint: String, httpMethod: HttpMethod) async throws -> T
}
