//
//  APIService.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import Foundation
import Combine
import os.log

enum APIError: Error {
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}

protocol APIServiceProtocol {
    func fetchProducts(url: String) -> AnyPublisher<[Product], Error>
    func fetchProductDetail(url: String) -> AnyPublisher<Product, Error>
    func fetchProductDescription(url: String) -> AnyPublisher<Description, Error>
}

class APIService: APIServiceProtocol {
    private let logger = Logger(subsystem: "com.MeLiMobileApp", category: "network")
    
    private func makeRequest<T: Decodable>(url: String, decodeTo type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: url) else {
            logger.error("Invalid URL: \(url)")
            return Fail(error: APIError.invalidResponse).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    self.logger.error("Invalid HTTP response: \(response)")
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error in
                self.logError("makeRequest", error: error)
                return self.mapApiError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchProducts(url: String) -> AnyPublisher<[Product], Error> {
        makeRequest(url: url, decodeTo: SearchResult.self)
            .map { $0.results }
            .eraseToAnyPublisher()
    }

    func fetchProductDetail(url: String) -> AnyPublisher<Product, Error> {
        makeRequest(url: url, decodeTo: Product.self)
    }

    func fetchProductDescription(url: String) -> AnyPublisher<Description, Error> {
        makeRequest(url: url, decodeTo: Description.self)
    }
    
    private func logError(_ functionName: String, error: Error) {
        logger.error("Error in \(functionName): \(error.localizedDescription)")
    }
    
    private func mapApiError(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            return .networkError(urlError)
        } else if let decodingError = error as? DecodingError {
            return .decodingError(decodingError)
        } else {
            return .invalidResponse
        }
    }
}
