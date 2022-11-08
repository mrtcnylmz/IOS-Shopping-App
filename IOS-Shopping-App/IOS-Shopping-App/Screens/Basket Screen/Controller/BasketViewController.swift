//
//  BasketViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import UIKit
import Firebase

class BasketViewController: UIViewController{
    
    @IBOutlet weak var BasketTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    var basketEntryListViewModel : BasketEntryListViewModel?{
        didSet {
            self.BasketTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.BasketTableView?.reloadData()
        self.BasketTableView.register(UINib(nibName: "BasketTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getTotalPrice { amount in
            self.totalPriceLabel.text = String(format: "%.2f", amount!)
        }
        
    }
    
    //MARK: - checkOutButtonAction
    @IBAction func checkOutButtonAction(_ sender: UIButton) {
        self.showIndicationSpinner()
        getTotalPrice { amount in
            self.totalPriceLabel.text = String(format: "%.2f", amount!)
            self.removeIndicationSpinner()
            AlertMaker.shared.basicCancelAlert(on: self, title: "Checkout", message: "Your total is \(amount!)$, do you wish to complete payment?") { _ in
                self.fireStore.collection("User_Baskets").document(self.userAuth.currentUser!.uid).collection("current_basket").getDocuments { query, error in
                    for doc in query!.documents {
                        doc.reference.delete()
                    }
                }
                AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Payment Successfull!") { _ in
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func getTotalPrice(complation: @escaping (Double?) -> Void) {
        var totalAmount : Double = 0.0
        fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("current_basket").getDocuments { querySnapshot, error in
            for doc in querySnapshot!.documents {
                var amount = Double((doc.data()["productPrice"] as! Double) * (doc.data()["productQuantity"] as! Double))
                totalAmount += amount
            }
            complation(totalAmount)
        }
    }
}

//MARK: - Extensions
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketEntryListViewModel!.numberOfRowsInSection()
    }
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let basketProductViewModel = self.basketEntryListViewModel!.productAtIndex(indexPath.row)
        totalPriceLabel.text = String(format: "%.2f", ((basketProductViewModel.productPrice * Double(basketProductViewModel.productQuantity)) + Double(totalPriceLabel.text!)!))
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BasketTableViewCell {
            cell.productNameLabel.text = basketProductViewModel.productName
            cell.productQuantityLabel.text = basketProductViewModel.productQuantity.description
            cell.stepper.value = Double(basketProductViewModel.productQuantity)
            cell.productId = String(basketProductViewModel.productId)
            cell.productPrice = basketProductViewModel.productPrice
            cell.productPriceLabel.text = String(format: "%.2f", (Double(basketProductViewModel.productQuantity) * basketProductViewModel.productPrice)) + "$"
            return cell
        }
        return BasketTableViewCell()
    }
    
    //MARK: - numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    //MARK: - titleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Basket"
    }
}
