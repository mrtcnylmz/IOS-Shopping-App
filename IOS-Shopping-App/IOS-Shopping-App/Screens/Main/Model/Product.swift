//
//  Product.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//
//   let product = try? newJSONDecoder().decode(Product.self, from: jsonData)


import Foundation

// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int?
    let title: String?
    let price: Double?
    let productDescription: String?
    let category: Category?
    let image: String?
    let rating: Rating?

    enum CodingKeys: String, CodingKey {
        case id, title, price
        case productDescription = "description"
        case category, image, rating
    }
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double?
    let count: Int?
}

typealias Product = [ProductElement]
