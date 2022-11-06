//
//  LaunchScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 6.11.2022.
//

import UIKit
import Firebase

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let auth = Auth.auth()
        let currentUser = auth.currentUser
    }
}
