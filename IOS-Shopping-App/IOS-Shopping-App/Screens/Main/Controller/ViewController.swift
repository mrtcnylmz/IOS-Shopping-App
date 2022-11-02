//
//  ViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("loaded")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            print("no url response")
            return
        }
        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
                return
            }
            
            guard let response = response else {
                return
            }
            
            let decoder 
        }
        dataTask.resume()
    }


}

