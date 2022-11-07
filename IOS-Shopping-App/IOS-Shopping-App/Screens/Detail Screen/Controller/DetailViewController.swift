//
//  DetailViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var addToBasketButton: UIButton!
    
    var product : ProductViewModel?
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    var itemm : BasketProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = product?.name
        detailImageView.downloadImage(from: product?.image)
        productNameLabel.text = product?.name
        productDescriptionLabel.text = product?.description
        productPriceLabel.text = "\(product!.price)$"
        productRatingLabel.text = String(repeating: "★", count: Int(product!.rating.rate)) +
        String(repeating: "☆", count: 5 - Int(product!.rating.rate)) +
        "(\(product!.rating.count))"
    }
    
    @IBAction func stepperAction(_ sender: UIStepper) {
        productAmountLabel.text = String(Int(sender.value))
    }
    
    @IBAction func addToBasketButtonAction(_ sender: UIButton) {
        self.showIndicationSpinner()
        
        let userDoc = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid)
        
        userDoc.getDocument { document, error in
        outerloop: if let document = document, document.exists {
            for data in document.data()!{
                if data.key as! String == String(self.product!.id) {
                    print("1")
                    let newQuantity = data.value as! Int + Int(self.productAmountLabel.text!)!
                    userDoc.setData([String(self.product!.id) : newQuantity],merge: true) { error in
                        self.removeIndicationSpinner()
                        if error == nil {
                            AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Items successfully added to basket!", okFunc: nil)
                        }else {
                            AlertMaker.shared.basicAlert(on: self, title: "Error", message: "An error occured, please try again later!", okFunc: nil)
                        }
                    }
                    break outerloop
                }
            }
            userDoc.setData([String(self.product!.id) : Int(self.productAmountLabel.text!)],merge: true) { error in
                self.removeIndicationSpinner()
                if error == nil {
                    AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Items successfully added to basket!", okFunc: nil)
                }else {
                    AlertMaker.shared.basicAlert(on: self, title: "Error", message: "An error occured, please try again later!", okFunc: nil)
                }
            }
        } else {
            userDoc.setData([String(self.product!.id) : Int(self.productAmountLabel.text!)],merge: true) { error in
                self.removeIndicationSpinner()
                if error == nil {
                    AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Items successfully added to basket!", okFunc: nil)
                }else {
                    AlertMaker.shared.basicAlert(on: self, title: "Error", message: "An error occured, please try again later!", okFunc: nil)
                }
                return
            }
        }
        }
        //        fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("basket").addDocument(data: productBasketDictionary){ error in
        //            if error == nil {
        //                AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Items successfully added to basket!", okFunc: nil)
        //            }else {
        //                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "An error occured, please try again later!", okFunc: nil)
        //            }
        //        }
    }
}
//        fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("basket").getDocuments { (snapshot, error) in
//                if let error = error {
//                    print(error)
//                    return
//                } else {
//                    var baskett = []
//                    for document in snapshot!.documents {
//                        let data = document.data()
//                        baskett.append(data)
//                    }
//                    print(baskett)
//                }
//            }
