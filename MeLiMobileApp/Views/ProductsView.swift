//
//  ProductsView.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 8/10/24.
//

import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    @State private var searchTerm = ""
    @State private var isSearching = false
    
    let columns = [
        GridItem(.adaptive(minimum: 170, maximum: 170))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.yellow.ignoresSafeArea()
                
                VStack {
                    SearchBar()
                    
                    if isSearching {
                        if viewModel.isFailure {
                            CustomAlertView(title: "Error", message: viewModel.errorMessage!, buttonTitle: "OK") {
                                viewModel.fetchProducts(searchTerm: searchTerm)
                            }
                            .transition(.scale)
                            .zIndex(1)
                        } else {
                            gridView()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    func SearchBar() -> some View {
        VStack {
            Text("txt_app_name")
                .padding()
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextField("", text: $searchTerm, prompt: Text("txtfield_search_product"))
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.2), radius: 5)
                    .onSubmit {
                        animate()
                    }
                    .submitLabel(.done)
                
                Button {
                    animate()
                } label: {
                    Text("btn_search")
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(15)
                }
                
            }
            .padding()
        }
    }
    
    func gridView() -> some View {
        withAnimation(.easeInOut(duration: 0.1)) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(viewModel.products) { product in
                        NavigationLink(destination: ProductDetailView(viewModel: ProductDetailViewModel(product: product))) {
                            ProductCell(product: product)
                                .frame(width: 170, height: 170)
                        }
                    }
                    .border(Color.gray)
                }
            }
            .padding()
            .background(Color.white)
        }
    }
    
    private func animate() {
        withAnimation(.bouncy(duration: 0.5)) {
            if !searchTerm.isEmpty {
                hideKeyboard()
                isSearching = true
                viewModel.fetchProducts(searchTerm: searchTerm)
            } else {
                hideKeyboard()
                isSearching = false
            }
        }
    }
}

#Preview {
    ProductsView()
}
