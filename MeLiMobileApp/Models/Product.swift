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
    var id: String
    var title: String
    var price: Double
    var thumbnail: String
}
