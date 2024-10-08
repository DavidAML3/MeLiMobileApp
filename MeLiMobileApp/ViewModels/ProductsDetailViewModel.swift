//
//  ProductsDetailViewModel.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 6/10/24.
//

import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productRepository: ProductRepositoryProtocol = ProductRepository()
    private var cancellables = Set<AnyCancellable>()

    init(product: Product) {
        self.product = product
    }

    func fetchProductDetails(productID: String) {
        isLoading = true
        
        productRepository.fetchProductDetail(productID: productID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Error al obtener el detalle del producto: \(error.localizedDescription)"
                case .finished:
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] product in
                self?.product = product
            }
            .store(in: &cancellables)

        productRepository.fetchProductDescription(productID: productID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Error al obtener la descripción: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] description in
                self?.product?.description = description.plain_text
            }
            .store(in: &cancellables)
    }
}
