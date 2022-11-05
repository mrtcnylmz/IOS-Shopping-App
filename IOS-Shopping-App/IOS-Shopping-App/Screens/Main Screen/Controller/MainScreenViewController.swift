//
//  MainScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 4.11.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productScreenController = ProductScreenViewController()
        let searchScreenController = SearchScreenViewController()
        let profileScreenController = ProfileScreenViewController()
        
        productScreenController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        searchScreenController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        profileScreenController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        let productNavigationController = UINavigationController(rootViewController: productScreenController)
        let searchNavigationController = UINavigationController(rootViewController: searchScreenController)
        let profileNavigationController = UINavigationController(rootViewController: profileScreenController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [productNavigationController, searchNavigationController, profileNavigationController]
    }
}
