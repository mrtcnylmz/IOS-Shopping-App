//
//  TabBarViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let productScreenController = ProductScreenViewController()
        let searchScreenController = SearchScreenViewController()
        let profileScreenController = ProfileScreenViewController()
        
        productScreenController.title = "Products"
        searchScreenController.title = "Search"
        profileScreenController.title = "Profile"
        
        productScreenController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "bag.circle"), selectedImage: UIImage(systemName: "bag.circle.fill"))
        searchScreenController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        profileScreenController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        
        let productNavigationController = UINavigationController(rootViewController: productScreenController)
        let searchNavigationController = UINavigationController(rootViewController: searchScreenController)
        let profileNavigationController = UINavigationController(rootViewController: profileScreenController)
        
        self.setViewControllers([productNavigationController, searchNavigationController, profileNavigationController], animated: true)
    }
}
