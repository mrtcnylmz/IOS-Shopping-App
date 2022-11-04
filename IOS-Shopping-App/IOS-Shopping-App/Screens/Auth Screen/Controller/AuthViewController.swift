//
//  AuthViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 3.11.2022.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTemplate()
        
        let hideKeyboardTapRec = UITapGestureRecognizer(target: self, action: #selector(hideKeyb))
        view.addGestureRecognizer(hideKeyboardTapRec)
        
    }
    
    func loginTemplate(){
        usernameTextField.isHidden = true
        passwordRepeatTextField.isHidden = true
        titleLabel.text = "Sign In!"
        signButton.setTitle("Login", for: .normal)
        signButton.tintColor = UIColor(named: "AccentColor")
    }
    
    func registerTemplate(){
        usernameTextField.isHidden = false
        passwordRepeatTextField.isHidden = false
        titleLabel.text = "Register!"
        signButton.setTitle("Register", for: .normal)
        signButton.tintColor = UIColor(named: "Color-2")
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            loginTemplate()
        default:
            registerTemplate()
        }
    }
    
    @IBAction func signButtonAction(_ sender: UIButton) {
    }
    
    // MARK: - hideKeyb
    @objc func hideKeyb(){
        view.endEditing(true)
    }
}
