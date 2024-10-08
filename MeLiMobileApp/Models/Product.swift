//
//  Item.swift
//  MeLiMobileApp
//
//  Created by David Andres Mejia Lopez on 5/10/24.
//

import Foundation

struct SearchResult: Codable {
    var results: [Product]
}

struct Product: Codable, Identifiable {
    let id: String
    let title: String
    let price: Double
    let thumbnail: String
    let available_quantity: Int
    let accepts_mercadopago: Bool
    let permalink: String
    let shipping: ShippingInfo
    let pictures: [ProductPicture]?
    var description: String?
}

struct ShippingInfo: Codable {
    let free_shipping: Bool
    let logistic_type: String
}

struct ProductPicture: Codable, Identifiable {
    let id: String
    let secure_url: String
}

struct Description: Codable {
    let plain_text: String
}
