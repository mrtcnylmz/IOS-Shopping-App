//
//  UIImageExtensionDownload.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 6.11.2022.
//

import UIKit

public let cache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    func downloadImage(from url: URL?) {
        guard let url = url else {
            return
        }
        
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            self.image = image
            return
        }
        
        let request = URLRequest(url: url)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
            guard let data = data,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            cache.setObject(image, forKey: url.absoluteString as NSString)
        }
        dataTask.resume()
    }
}
