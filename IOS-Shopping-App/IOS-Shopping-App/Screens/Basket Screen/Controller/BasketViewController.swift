//
//  BasketViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import UIKit
import Firebase

class BasketViewController: UIViewController {
    
    @IBOutlet weak var BasketTableView: UITableView!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    var basketProducts : [BasketProduct] = []
    
    override var title : String?{
        didSet {
            DispatchQueue.main.async {
                self.BasketTableView.reloadData()
            }
        }
    }
    
    private var basketItemListViewModel : BasketItemListViewModel?{
        didSet {
            print("didSet")
            self.BasketTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Load")
        
        self.BasketTableView.register(UINib(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getData()
    }
    
    func getData() {
        
        print("Get Data")
        
        let userDoc = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid)
        
        userDoc.getDocument { document, error in
            if let document = document, document.exists {
                for data in document.data()! {
                    var item = BasketProduct(productId: Int(data.key)!, quantity: data.value as! Int)
                    print("item: \(item)")
                    self.basketProducts.append(item)
                }
                print("basketProducts: \(self.basketProducts)")
                self.basketItemListViewModel? = BasketItemListViewModel(basketProductList: self.basketProducts)
                
            }
        }
    }
}
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Int-> \(self.basketProducts.count)")
        return self.basketProducts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let basketProductViewModel = self.basketProducts[indexPath.item]
        StoreAPI.shared.fetchProduct(productId: String(basketProductViewModel.productId)) { product, error in
            
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BasketTableViewCell {
            StoreAPI.shared.fetchProduct(productId: String(basketProductViewModel.productId)) { product, error in
                self.title = product!.title
            }
            cell.productNameLabel.text = title
            cell.productQuantityLabel.text = (String(basketProductViewModel.quantity))
            return cell
        }
        return BasketTableViewCell()
    }
    
}
