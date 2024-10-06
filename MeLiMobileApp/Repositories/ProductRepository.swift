//
//  ProductRepository.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func fetchProducts(searchTerm: String) -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchProducts(searchTerm: String) -> AnyPublisher<[Product], Error> {
        let url = "https://api.mercadolibre.com/sites/MCO/search?q=\(searchTerm)"
        return apiService.fetch(url: url)
    }
}
