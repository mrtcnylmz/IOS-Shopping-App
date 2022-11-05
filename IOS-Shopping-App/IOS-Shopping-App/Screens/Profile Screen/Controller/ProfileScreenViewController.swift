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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomProfileTableViewCell {
            if indexPath.section == 1 && indexPath.row == 1 {
                cell.subtitleLabel.text = "Sign Out"
                cell.titleLabel.text = ""
                cell.subtitleLabel.textColor = .red
                cell.imageView?.image = .remove
                return cell
            }else {
                return cell
            }
        }
        return CustomProfileTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return 2
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "User Info"
        }else {
            return "User Settings"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            print("Sign out Function")
            signOutButtonAction(0)
        }
    }
    
    @IBAction func signOutButtonAction(_ sender: Any) {
        
        AlertMaker.shared.basicCancelAlert(on: self, title: "Signing Out", message: "Are you sure you want to sign out?") { _ in
            do {
                try Auth.auth().signOut()
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
}
