//
//  StoreAPI.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import Foundation

final class StoreAPI {
    static let shared = StoreAPI()
    
    //MARK: - FetchProducts
    func fetchProducts(complation: @escaping ([Product]?,Error?) -> Void) {
        let url = URL(string: "https://fakestoreapi.com/products")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                complation(nil,error!)
                return
            }
            guard response != nil else {
                fatalError("No Response!")
            }
            
            guard data != nil else {
                fatalError("No Data!")
            }
            
            let productList = try? JSONDecoder().decode([Product].self, from: data!)
            complation(productList,nil)
        }.resume()
    }
    
    //MARK: - FetchProduct
    func fetchProduct(productId : String, complation: @escaping (Product?,Error?) -> Void) {
        let url = URL(string: "https://fakestoreapi.com/products/\(productId)")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                complation(nil,error!)
                return
            }
            guard response != nil else {
                fatalError("No Response!")
            }
            
            guard data != nil else {
                fatalError("No Data!")
            }
            
            let product = try? JSONDecoder().decode(Product.self, from: data!)
            complation(product, nil)
        }.resume()
    }
    
    
    //MARK: - FetchProductsByCatagory
    func fetchProductsByCatagory(productCatagory : String, complation: @escaping ([Product]?,Error?) -> Void) {
        let url = URL(string: "https://fakestoreapi.com/products/category/" + productCatagory)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                complation(nil,error!)
                return
            }
            guard response != nil else {
                fatalError("No Response!")
            }
            
            guard data != nil else {
                fatalError("No Data!")
            }
            
            let productList = try? JSONDecoder().decode([Product].self, from: data!)
            complation(productList,nil)
        }.resume()
    }
}
