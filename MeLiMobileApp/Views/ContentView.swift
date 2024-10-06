//
//  ContentView.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.products) { product in
                        HStack {
                            AsyncImage(url: URL(string: product.thumbnail)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                            
                            VStack(alignment: .leading) {
                                Text(product.title)
                                    .font(.headline)
                                Text(String(format: "$%.2f", product.price))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .onAppear {
                viewModel.fetchProducts(searchTerm: "iphone")
            }
        }
    }
}

#Preview {
    ContentView()
}
