//
//  DetailViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import UIKit
import Firebase

final class DetailViewController: UIViewController {
    
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
    
    //MARK: - ViewDidLoad
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
        checkBasket()
    }
    
    //MARK: - StepperAction
    @IBAction func stepperAction(_ sender: UIStepper) {
        productAmountLabel.text = String(Int(sender.value))
    }
    
    //MARK: - CheckBasket
    func checkBasket() {
        let docRef = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("current_basket").document(product!.id.description)
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let amount = document.data()!["productQuantity"]
                self?.productAmountLabel.text = "\(amount!)"
                self?.stepper.value = Double(amount as! Int)
                self?.addToBasketButton.setTitle("Update The Basket", for: .normal)
            }
        }
    }
    
    //MARK: - AddToBasketButtonAction
    @IBAction func addToBasketButtonAction(_ sender: UIButton) {
        if self.productAmountLabel.text == "0" {
            let docRef = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("current_basket").document(product!.id.description)
            
            docRef.getDocument { [weak self] (document, error) in
                
                if let document = document, document.exists {
                    self?.showIndicationSpinner()
                    docRef.delete { error in
                        self?.removeIndicationSpinner()
                        if error == nil {
                            AlertMaker.shared.basicAlert(on: self!, title: "Success", message: "Items removed from basket!") { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }else {
                            AlertMaker.shared.basicAlert(on: self!, title: "Error", message: "An error occured, please try again later!") { _ in
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }else {
            self.showIndicationSpinner()
            let userBasket = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("current_basket")
            let basketEntrie = [
                "productName": product!.name,
                "productId": product!.id,
                "productQuantity": Int(self.productAmountLabel.text!)!,
                "productPrice": product!.price
            ]as [String: Any]
            
            userBasket.document("\(self.product!.id)").setData(basketEntrie, merge: true) { [weak self] error in
                self?.removeIndicationSpinner()
                if error == nil {
                    AlertMaker.shared.basicAlert(on: self!, title: "Success", message: "Basket Updated!") { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }else {
                    AlertMaker.shared.basicAlert(on: self!, title: "Error", message: "An error occured, please try again later!") { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
