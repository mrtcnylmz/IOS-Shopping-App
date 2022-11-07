//
//  UserViewModel.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import Foundation

struct UserViewModel {
    let user : User
}

extension UserViewModel {
    var id : String {
        return self.user.id
    }
    
    var name : String {
        return self.user.name
    }
    
    var email : String {
        return self.user.email
    }
    
    func numberOfRowsInSection() -> Int {
        return 3
    }
}
