//
//  ProfileScreenViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 5.11.2022.
//

import UIKit
import Firebase

class ProfileScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userInfo : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfo = getUserData()
        
        self.tableView.register(UINib(nibName: "CustomProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    func getUserData() -> User {
        var user : User?
        if let data = UserDefaults.standard.data(forKey: "currentUserInfo") {
            user = try! PropertyListDecoder().decode(User.self, from: data)
        }
        return user!
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "USER INFO"
        default:
            return "USER SETTINGS"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                passwordReset()
            default:
                signOutButtonAction(0)
            }
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        
        AlertMaker.shared.basicCancelAlert(on: self, title: "Signing Out", message: "Are you sure you want to sign out?") { _ in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set(nil, forKey: "currentUserInfo")
                print("Sign Out")
                let authViewController = AuthViewController(nibName: "AuthViewController", bundle: nil)
                authViewController.modalPresentationStyle = .fullScreen
                authViewController.modalTransitionStyle = .coverVertical
                self.present(authViewController, animated: true, completion: nil)
                // TODO: - Make alerts inc. catch
            }catch {
                AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Failed to Sign Out!", okFunc: nil)
            }
        }
    }
    
    func passwordReset() {
        AlertMaker.shared.basicCancelAlert(on: self, title: "Password Reset", message: "Are you sure you want to reset your password?") { _ in
            Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { error in
                if error != nil{
                    AlertMaker.shared.basicAlert(on: self, title: "⚠️ Error", message: error?.localizedDescription ?? "Failure.", okFunc: nil)
                }else {
                    AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Please check your email for further steps.", okFunc: nil)
                }
            }
        }
    }
}
