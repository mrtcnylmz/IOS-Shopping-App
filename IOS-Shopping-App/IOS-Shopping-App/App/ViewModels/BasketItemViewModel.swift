//
//  BasketItemViewModel.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import Foundation

struct BasketItemListViewModel {
    let basketProductList : [BasketProduct]
}

extension BasketItemListViewModel {
    func numberOfRowsInSection() -> Int {
        return self.basketProductList.count
    }
    
    func productAtIndex(_ index: Int) -> BasketItemViewModel {
        let productAtIndex = self.basketProductList[index]
        return BasketItemViewModel(basketProduct: productAtIndex)
    }
}

struct BasketItemViewModel {
    let basketProduct : BasketProduct
}

extension BasketItemViewModel {
    var productId : Int {
        return self.basketProduct.productId
    }
    
    var quantity : Int {
        return self.basketProduct.quantity
    }
}
