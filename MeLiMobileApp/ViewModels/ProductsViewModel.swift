//
//  ProductsViewModel.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 6/10/24.
//

import Foundation
import Combine

class ProductsViewModel: ObservableObject {
    @Published var products = [Product]()
    @Published var isLoading = false
    @Published var isFailure = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol = ProductRepository()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProducts(searchTerm: String) {
        isLoading = true
        repository.fetchProducts(searchTerm: searchTerm)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.isFailure = true
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] products in
                self?.products = products
            }
            .store(in: &cancellables)
    }
}
