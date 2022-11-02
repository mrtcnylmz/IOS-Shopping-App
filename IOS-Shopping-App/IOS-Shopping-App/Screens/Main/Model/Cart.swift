//
//  Cart.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import Foundation

// MARK: - Cart
struct Cart: Codable {
    let id, userID: Int?
    let date: String?
    let products: [Products]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case date, products
        case v = "__v"
    }
}

// MARK: - Product
struct Products: Codable {
    let productID, quantity: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case quantity
    }
}
