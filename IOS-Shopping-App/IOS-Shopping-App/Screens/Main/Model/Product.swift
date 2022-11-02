//
//  Product.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let productDescription, category: String?
    let image: String?
    let rating: Rating?

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case productDescription = "description"
        case category, image, rating
    }
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double?
    let count: Int?
}
