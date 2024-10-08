//
//  ProductRepository.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import Foundation
import Combine
import os.log

protocol ProductRepositoryProtocol {
    func fetchProducts(searchTerm: String) -> AnyPublisher<[Product], Error>
    func fetchProductDetail(productID: String) -> AnyPublisher<Product, Error>
    func fetchProductDescription(productID: String) -> AnyPublisher<Description, Error>
}

class ProductRepository: ProductRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let logger = Logger(subsystem: "com.MeLiMobileApp.ProductRepository", category: "network")
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchProducts(searchTerm: String) -> AnyPublisher<[Product], Error> {
        let url = "https://api.mercadolibre.com/sites/MCO/search?q=\(searchTerm)"
        return apiService.fetchProducts(url: url)
            .catch { error -> AnyPublisher<[Product], Error> in
                self.logError("Error fetching products for searchTerm: \(searchTerm)", error: error)
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchProductDetail(productID: String) -> AnyPublisher<Product, Error> {
        let url = "https://api.mercadolibre.com/items/\(productID)"
        return apiService.fetchProductDetail(url: url)
            .catch { error -> AnyPublisher<Product, Error> in
                self.logError("Error fetching product detail for productID: \(productID)", error: error)
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchProductDescription(productID: String) -> AnyPublisher<Description, Error> {
        let url = "https://api.mercadolibre.com/items/\(productID)/description"
        return apiService.fetchProductDescription(url: url)
            .catch { error -> AnyPublisher<Description, Error> in
                self.logError("Error fetching product description for productID: \(productID)", error: error)
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func logError(_ message: String, error: Error) {
        logger.error("\(message): \(error.localizedDescription)")
    }
}
