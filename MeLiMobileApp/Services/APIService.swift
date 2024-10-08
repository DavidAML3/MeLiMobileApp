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
    func fetchProducts(url: String) -> AnyPublisher<[Product], Error>
    func fetchProductDetail(url: String) -> AnyPublisher<Product, Error>
    func fetchProductDescription(url: String) -> AnyPublisher<Description, Error>
}

class APIService: APIServiceProtocol {
    func fetchProducts(url: String) -> AnyPublisher<[Product], Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    func fetchProductDetail(url: String) -> AnyPublisher<Product, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Product.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchProductDescription(url: String) -> AnyPublisher<Description, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Description.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
