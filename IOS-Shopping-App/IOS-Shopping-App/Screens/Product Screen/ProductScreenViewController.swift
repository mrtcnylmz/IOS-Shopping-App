//
//  ProductScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit
import Firebase

class ProductScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Product"
        
    }

    @IBAction func signOutButtonAction(_ sender: Any) {
        
        AlertMaker.shared.basicCancelAlert(on: self, title: "Signing Out", message: "Are you sure you want to sign out?") { _ in
            do {
                try Auth.auth().signOut()
                print("Sign Out")
                let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
                authViewController.modalPresentationStyle = .fullScreen
                authViewController.modalTransitionStyle = .coverVertical
                self.present(authViewController, animated: true, completion: nil)
                // TODO: - Make alerts inc. catch
            }catch {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Failed to Sign Out!", okFunc: nil)
            }
        }
    }

}
