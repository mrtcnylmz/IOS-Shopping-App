//
//  BasketTableViewCell.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 7.11.2022.
//

import UIKit
import Firebase

final class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    var productId: String?
    var productPrice: Double?
    
    //MARK: - AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - StepperAction
    @IBAction func stepperAction(_ sender: Any) {
        let stepperValue = Int(stepper.value)
        let userBasket = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid).collection("current_basket")
        productQuantityLabel.text = String(Int(stepper.value))
        productPriceLabel.text = String(format: "%.2f", (productPrice! * stepper.value)) + "$"
        
        if stepperValue == 0 {
            userBasket.document(productId!).delete()
        }else {
            userBasket.document(productId!).setData(["productQuantity" : stepperValue],merge: true)
        }
    }
    
    //MARK: - SetSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
