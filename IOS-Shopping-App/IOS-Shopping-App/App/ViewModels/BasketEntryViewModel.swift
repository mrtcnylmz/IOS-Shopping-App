//
//  BasketEntryViewModel.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import Foundation

struct BasketEntryListViewModel {
    let basketEntryList : [BasketEntry]
}

extension BasketEntryListViewModel {
    func numberOfRowsInSection() -> Int {
        return self.basketEntryList.count
    }
    
    func productAtIndex(_ index: Int) -> BasketEntryViewModel {
        let productAtIndex = self.basketEntryList[index]
        return BasketEntryViewModel(basketEntry: productAtIndex)
    }
}

struct BasketEntryViewModel {
    let basketEntry : BasketEntry
}

extension BasketEntryViewModel {
    var productId : Int {
        return self.basketEntry.productId
    }
    
    var productName : String {
        return self.basketEntry.productName
    }
    
    var productQuantity : Int {
        return self.basketEntry.productQuantity
    }
    
    var productPrice: Double {
        return self.basketEntry.productPrice
    }
    
    var entryId : String {
        return self.basketEntry.entryId
    }
}
