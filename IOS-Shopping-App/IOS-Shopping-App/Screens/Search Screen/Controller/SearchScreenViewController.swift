//
//  SearchScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit
import Firebase

class SearchScreenViewController: UIViewController {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchSegmentedControl: UISegmentedControl!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    var products : [Product]?
    
    let searchController = UISearchController()
    
    private var productListViewModel : ProductListViewModel?{
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(toBasket))
        
        let hideKeyboardTapRec = UITapGestureRecognizer(target: self, action: #selector(hideKeyb))
        searchCollectionView.addGestureRecognizer(hideKeyboardTapRec)
        
        searchController.searchBar.placeholder = "Products..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        self.searchCollectionView.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "searchCollectionCell")
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        self.searchCollectionView.setCollectionViewLayout(layout, animated: true)
        getData()
    }
    
    // MARK: - toBasket
    @objc func toBasket() {
        let basketViewController = BasketViewController()
        
        getBasketData { basketEntryListViewModel in
            basketViewController.basketEntryListViewModel = basketEntryListViewModel!
            self.present(basketViewController, animated: true)
        }
    }
    
    //MARK: - getBasketData
    func getBasketData(complation: @escaping (BasketEntryListViewModel?) -> Void) {
        let basketViewController = BasketViewController()
        let userDoc = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid)
        let userBasket = userDoc.collection("current_basket")
        var basketEntryArray: [BasketEntry] = []
        var dataArr: [[String : Any]] = []
        
        userBasket.getDocuments { querySnapshot, error in
            
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Network Error", okFunc: nil)
                return
            }
            
            for document in querySnapshot!.documents {
                dataArr.append(document.data())
            }
            
            for data in dataArr {
                let basEnt = BasketEntry(productId: data["productId"] as! Int,
                                         productName: data["productName"] as! String,
                                         productQuantity: data["productQuantity"] as! Int,
                                         productPrice: data["productPrice"] as! Double,
                                         entryId: (data["productId"] as! Int).description)
                basketEntryArray.append(basEnt)
            }
            
            let basketEntryViewModel = BasketEntryListViewModel(basketEntryList: basketEntryArray)
            complation(basketEntryViewModel)
        }
    }
    
    // MARK: searchSegmentedControlAction
    @IBAction func searchSegmentedControlAction(_ sender: UISegmentedControl) {
        getData()
    }
    
    // MARK: getProducts
    func getProducts() {
        StoreAPI.shared.fetchProducts { productList, error in
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Network having issues, try again.", okFunc: nil)
                return
            }
            if let productList = productList {
                self.productListViewModel = ProductListViewModel(productList: productList)
                self.products = productList
            }
        }
    }
    
    // MARK: getProductsByCatagory
    func getProductsByCatagory(catagory : String) {
        StoreAPI.shared.fetchProductsByCatagory(productCatagory: catagory) { productList, error in
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Network having issues, try again.", okFunc: nil)
                return
            }
            if let productList = productList {
                self.productListViewModel = ProductListViewModel(productList: productList)
                self.products = productList
            }
        }
    }
    
    // MARK: getData
    func getData() {
        switch searchSegmentedControl.selectedSegmentIndex{
        case 0:
            getProducts()
            searchController.searchBar.placeholder = "Products..."
            return
        case 1:
            getProductsByCatagory(catagory: "electronics")
            searchController.searchBar.placeholder = "Electronics..."
            return
        case 2:
            getProductsByCatagory(catagory: "jewelery")
            searchController.searchBar.placeholder = "Jewelery..."
            return
        case 3:
            getProductsByCatagory(catagory: "men's%20clothing")
            searchController.searchBar.placeholder = "Men's Clothing..."
            return
        default:
            getProductsByCatagory(catagory: "women's%20clothing")
            searchController.searchBar.placeholder = "Women's Clothing..."
            return
        }
    }
    
    // MARK: - Touch Keyboard Hide
    @objc func hideKeyb(){
        view.endEditing(true)
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchScreenViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        var filteredProductList : [Product] = []
        
        if let text = searchController.searchBar.text, text.count > 1 {
            for product in products! {
                if product.title.contains(text) {
                    filteredProductList.append(product)
                }
            }
            self.productListViewModel = ProductListViewModel(productList: filteredProductList)
        }else if searchController.searchBar.text!.isEmpty as Bool {
            self.productListViewModel = ProductListViewModel(productList: products!)
        }
    }
}

// MARK: - UICollectionView
extension SearchScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.productListViewModel?.numberOfRowsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.hidesBottomBarWhenPushed = true
        detailViewController.product = self.productListViewModel!.productAtIndex(indexPath.item)
        navigationController?.pushViewController(detailViewController, animated: true)
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
