//
//  ProductCell.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 6/10/24.
//

import SwiftUI

struct ProductCell: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: product.thumbnail)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
            .cornerRadius(8)
            
            Text(product.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text(product.price, format: .currency(code: "COP"))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .background(Color(UIColor.white))
    }
}
