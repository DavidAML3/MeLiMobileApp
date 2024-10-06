//
//  APIService.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidResponse
    case networkError
}

protocol APIServiceProtocol {
    func fetch(url: String) -> AnyPublisher<[Product], Error>
}

class APIService: APIServiceProtocol {
    func fetch(url: String) -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}
