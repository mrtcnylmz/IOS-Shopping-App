//
//  Product.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//
//   let product = try? newJSONDecoder().decode(Product.self, from: jsonData)


import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let productDescription: String
    let category: String
    let image: URL
    let rating: Rating

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
        case productDescription = "description"
        case category = "category"
        case image = "image"
        case rating = "rating"
    }
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int

    enum CodingKeys: String, CodingKey {
        case rate = "rate"
        case count = "count"
    }
}
