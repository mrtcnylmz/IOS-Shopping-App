//
//  MainScreenViewModel.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import Foundation

struct ProductListViewModel {
    let productList : [Product]
}

extension ProductListViewModel {
    func numberOfRowsInSection() -> Int {
        return self.productList.count
    }
    
    func productAtIndex(_ index: Int) -> ProductViewModel {
        let productAtIndex = self.productList[index]
        return ProductViewModel(product: productAtIndex)
    }
}

struct ProductViewModel {
    let product : Product
}

extension ProductViewModel {
    var id : Int {
        return self.product.id
    }
    
    var name : String {
        return self.product.title
    }
    
    var description : String {
        return self.product.productDescription
    }
    
    var category : String {
        return self.product.category
    }
    
    var price : Double {
        return self.product.price
    }
    
    var rating : Rating {
        return self.product.rating
    }
    
    var image : URL {
        return self.product.image
    }
}
