//
//  ProductDetailView.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 6/10/24.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ProductDetailViewModel
    
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            
            if let product = viewModel.product {
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .bold))
                                .padding()
                        }
                        Text("txt_details")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .bold()
                        Spacer()
                    }
                    
                    ScrollView {
                        Text(product.title)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if let pictures = product.pictures {
                            TabView {
                                ForEach(pictures) { picture in
                                    AsyncImage(url: URL(string: picture.secure_url)) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(maxHeight: 300)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .frame(height: 300)
                        } else {
                            AsyncImage(url: URL(string: product.thumbnail)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 300)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text(product.price, format: .currency(code: "COP"))
                            .font(.title)
                            .foregroundColor(.blue)
                        
                        if let description = product.description {
                            Text(description)
                                .padding(.top)
                                .foregroundColor(.black)
                        } else {
                            ProgressView("txt_loading_description")
                        }
                        
                        HStack {
                            if product.shipping.free_shipping {
                                Text("txt_free_shipping")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            } else {
                                Text("txt_cost_shipping")
                                    .foregroundColor(.red)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .scrollIndicators(.hidden)
                }
            } else {
                ProgressView("txt_loading_products_details")
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.fetchProductDetails(productID: viewModel.product?.id ?? "")
        }
    }
}

#Preview {
    ProductDetailView(viewModel: ProductDetailViewModel(product: Product(id: "Test1234", title: "Este es un titulo de prueba", price: 1234567890, thumbnail: "http://mla-s1-p.mlstatic.com/980849-MLA31002261498_062019-O.jpg", available_quantity: 34, accepts_mercadopago: true, permalink: "", shipping: ShippingInfo(free_shipping: true, logistic_type: ""), pictures: nil, description: "Este es un producto de prueba")))
}
