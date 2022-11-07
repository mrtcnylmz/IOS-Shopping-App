//
//  ProductScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit
import Firebase

class ProductScreenViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    private var productListViewModel : ProductListViewModel?{
        didSet {
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Products"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(toBasket))
        getProducts()
        self.productsCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCollectionCell")
    }
    
    func getProducts() {
        StoreAPI.shared.fetchProducts { productList, error in
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Network having issues, try again.", okFunc: nil)
                return
            }
            
            if let productList = productList {
                self.productListViewModel = ProductListViewModel(productList: productList)
            }
        }
    }
    
    @objc func toBasket() {
        let basketViewController = BasketViewController()
        self.present(basketViewController, animated: true)
    }
}

extension ProductScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        detailViewController.product = self.productListViewModel!.productAtIndex(indexPath.item)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.productListViewModel?.numberOfRowsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCollectionCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        let productViewModel = self.productListViewModel!.productAtIndex(indexPath.item)
        cell.productTitleLabel.text = productViewModel.name
        cell.productRatingLabel.text = String(repeating: "★", count: Int(productViewModel.rating.rate)) + String(repeating: "☆", count: 5 - Int(productViewModel.rating.rate)) + "(\(productViewModel.rating.count))"
        cell.productPriceLabel.text =  "\(productViewModel.price)\u{24}"
        cell.productImageView.downloadImage(from: productViewModel.image)
        cell.productImageView.layer.cornerRadius = 8.0
        cell.productImageView.backgroundColor = .white
        cell.layer.cornerRadius = 8.0
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 1.25
        cell.layer.shadowOpacity = 0.75
        cell.layer.masksToBounds = false
        
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - gridLayout.minimumInteritemSpacing
        return CGSize(width:widthPerItem, height:(widthPerItem * 1.5))
    }
}
