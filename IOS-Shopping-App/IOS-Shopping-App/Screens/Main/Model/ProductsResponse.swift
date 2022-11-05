//
//  ProductsResponse.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 3.11.2022.
//
//  TODO: Will be deleted

import Foundation

struct ProductsResponse: Decodable {
    let results: [Product]?
}
