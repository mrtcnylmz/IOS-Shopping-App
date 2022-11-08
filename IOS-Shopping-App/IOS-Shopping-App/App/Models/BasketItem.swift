//
//  BasketItem.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import Foundation

// MARK: - BasketProduct
struct BasketProduct: Codable {
    let productId: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case quantity = "quantity"
    }
}
