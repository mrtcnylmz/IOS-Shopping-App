//
//  BasketEntry.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import Foundation

// MARK: - BasketEntry
struct BasketEntry: Codable {
    let productId: Int
    let productName: String
    let productQuantity: Int
    let productPrice: Double
    let entryId: String

    enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case productName = "productName"
        case productQuantity = "productQuantity"
        case productPrice = "productPrice"
        case entryId = "entryId"
    }
}
