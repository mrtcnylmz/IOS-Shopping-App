//
//  StoreAPI.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import Foundation

final class StoreAPI {
    static let shared = StoreAPI()
    
    func fetchUrl(complation: @escaping (Product?,Error?) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: "https://fakestoreapi.com/products")
        let dataTask = urlSession.dataTask(with: URLRequest(url: url!)) { data, response, error in
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
                
            let decoder = JSONDecoder()
            let product = try? decoder.decode(Product.self, from: data!)
            complation(product,nil)
        }
        dataTask.resume()
    }
}
