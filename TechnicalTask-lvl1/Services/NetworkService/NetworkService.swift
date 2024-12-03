//
//  NetworkService.swift
//  TechnicalTask-lvl1
//
//  Created by Сергей Матвеенко on 25.11.24.
//

import Foundation

struct NetworkService: NetworkServiceProtocol {
    func requestData<T: Codable>(toEndPoint: String, httpMethod: HttpMethod) async throws -> T {
        guard let requestUrl = URL(string: toEndPoint) else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = httpMethod.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let resultData = try decoder.decode(T.self, from: data)
        return resultData
    }
}

enum HttpMethod: String {
    case get = "GET"
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
}
