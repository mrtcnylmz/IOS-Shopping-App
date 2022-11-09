//
//  ProfileScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit
import Firebase

final class ProfileScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    var userInfo : User?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .done, target: self, action: #selector(toBasket))
        userInfo = getUserData()
        self.tableView.register(UINib(nibName: "CustomProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    // MARK: - To Basket
    @objc func toBasket() {
        let basketViewController = BasketViewController()
        
        getBasketData { [weak self] basketEntryListViewModel in
            basketViewController.basketEntryListViewModel = basketEntryListViewModel!
            self!.present(basketViewController, animated: true)
        }
    }
    
    //MARK: - GetBasketData
    func getBasketData(complation: @escaping (BasketEntryListViewModel?) -> Void) {
        let userDoc = fireStore.collection("User_Baskets").document(userAuth.currentUser!.uid)
        let userBasket = userDoc.collection("current_basket")
        var basketEntryArray: [BasketEntry] = []
        var dataArr: [[String : Any]] = []
        
        userBasket.getDocuments { [weak self] querySnapshot, error in
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self!, title: "Error", message: "Network Error", okFunc: nil)
                return
            }
            for document in querySnapshot!.documents {
                dataArr.append(document.data())}
            
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
    
    // MARK: - GetUserData
    func getUserData() -> User {
        var user : User?
        if let data = UserDefaults.standard.data(forKey: "currentUserInfo") {
            user = try! PropertyListDecoder().decode(User.self, from: data)
        }
        return user!
    }
    
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomProfileTableViewCell {
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    cell.subtitleLabel.text = userInfo?.name
                    cell.titleLabel.text = "Name"
                    cell.imageView?.image = UIImage(systemName: "person")
                    return cell
                case 1:
                    cell.subtitleLabel.text = userInfo?.email
                    cell.titleLabel.text = "Email"
                    cell.imageView?.image = UIImage(systemName: "envelope")
                    return cell
                default:
                    cell.subtitleLabel.text = userInfo?.id
                    cell.titleLabel.text = "User ID"
                    cell.imageView?.image = UIImage(systemName: "number")
                    return cell
                }
            default:
                switch indexPath.row {
                case 0:
                    cell.subtitleLabel.text = ""
                    cell.titleLabel.text = "Reset Password"
                    cell.imageView?.image = UIImage(systemName: "key")
                    return cell
                case 1:
                    cell.subtitleLabel.text = ""
                    cell.titleLabel.text = "Reset Onboarding"
                    cell.imageView?.image = UIImage(systemName: "questionmark.circle")
                    return cell
                default:
                    cell.subtitleLabel.text = ""
                    cell.titleLabel.text = "Sign Out"
                    cell.titleLabel.textColor = .red
                    cell.imageView?.image = .remove
                    return cell
                }
            }
        }
        return CustomProfileTableViewCell()
    }
    
    // MARK: - NumberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 3
        }
    }
    
    // MARK: - NumberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    // MARK: - TitleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "USER INFO"
        default:
            return "USER SETTINGS"
        }
    }
    
    // MARK: - Did Select Row At
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                passwordReset()
            case 1:
                UserDefaults.standard.set(false, forKey: "isOnboardingShown")
                let onboardingViewController = OnboardingViewController()
                onboardingViewController.hidesBottomBarWhenPushed = true
                onboardingViewController.navigationItem.setHidesBackButton(true, animated: false)
                onboardingViewController.modalPresentationStyle = .formSheet
                navigationController?.present(onboardingViewController, animated: true)
            default:
                signOutButtonAction(0)
            }
        }
    }
    
    // MARK: - SignOutButtonAction
    @IBAction func signOutButtonAction(_ sender: Any) {
        AlertMaker.shared.basicCancelAlert(on: self, title: "Signing Out", message: "Are you sure you want to sign out?") { _ in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set(nil, forKey: "currentUserInfo")
                let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
                authViewController.modalPresentationStyle = .fullScreen
                authViewController.modalTransitionStyle = .coverVertical
                self.present(authViewController, animated: true, completion: nil)
            }catch {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Failed to Sign Out!", okFunc: nil)
            }
        }
    }
    
    // MARK: - Password Reset
    func passwordReset() {
        AlertMaker.shared.basicCancelAlert(on: self, title: "Password Reset", message: "Are you sure you want to reset your password?") { _ in
            Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { [weak self] error in
                if error != nil{
                    AlertMaker.shared.basicAlert(on: self!, title: "⚠️ Error", message: error?.localizedDescription ?? "Failure.", okFunc: nil)
                }else {
                    AlertMaker.shared.basicAlert(on: self!, title: "Success", message: "Please check your email for further steps.", okFunc: nil)
                }
            }
        }
    }
}
