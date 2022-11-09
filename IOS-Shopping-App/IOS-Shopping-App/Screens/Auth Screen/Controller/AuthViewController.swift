//
//  AuthViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 3.11.2022.
//

import UIKit
import Firebase

final class AuthViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordRepeatTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    let userAuth = Auth.auth()
    let fireStore = Firestore.firestore()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTemplate()
        
        let hideKeyboardTapRec = UITapGestureRecognizer(target: self, action: #selector(hideKeyb))
        view.addGestureRecognizer(hideKeyboardTapRec)
    }
    
    // MARK: - ViewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        guard let isOnboardingShown = UserDefaults.standard.value(forKey: "isOnboardingShown"), isOnboardingShown as! Bool == true else {
            onboarding()
            return
        }
    }
    
    // MARK: - Login Form
    func loginTemplate(){
        usernameTextField.isHidden = true
        passwordRepeatTextField.isHidden = true
        titleLabel.text = "Sign In!"
        titleLabel.textColor = UIColor(named: "AccentColor")
        signButton.setTitle("Login", for: .normal)
        signButton.backgroundColor = UIColor(named: "AccentColor")
        signButton.tintColor = .white
    }
    
    // MARK: - Registery Form
    func registerTemplate(){
        usernameTextField.isHidden = false
        passwordRepeatTextField.isHidden = false
        titleLabel.text = "Register!"
        titleLabel.textColor = UIColor(named: "Color-2")
        signButton.setTitle("Register", for: .normal)
        signButton.backgroundColor = UIColor(named: "Color-2")
        signButton.tintColor = .white
    }
    
    // MARK: - Segmented Control
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            loginTemplate()
        default:
            registerTemplate()
        }
    }
    
    // MARK: - Sign Button Actions
    @IBAction func signButtonAction(_ sender: UIButton) {
        switch segmentControl.selectedSegmentIndex{
        case 0:
            login()
        default:
            register()
        }
    }
    
    //MARK: - Login
    func login(){
        self.showIndicationSpinner()
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            self!.removeIndicationSpinner()
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self!, title: "Error", message: error!.localizedDescription, okFunc: nil)
                return
            }
            
            let userInfo : User = User(id: (authResult?.user.uid)!,
                                       name: (authResult?.user.displayName)!,
                                       email: (authResult?.user.email)!)
            
            if let data = try? PropertyListEncoder().encode(userInfo) {
                UserDefaults.standard.set(data, forKey: "currentUserInfo")
            }
            
            if Auth.auth().currentUser != nil {
                let tabBar = TabBarViewController()
                tabBar.modalTransitionStyle = .coverVertical
                tabBar.modalPresentationStyle = .fullScreen
                self!.present(tabBar, animated: true)
            }
        }
    }
    
    //MARK: - Register
    func register(){
        
        guard passwordTextField.text == passwordRepeatTextField.text else {
            AlertMaker.shared.basicAlert(on: self, title: "Error", message: "Please repeat the password correctly.", okFunc: nil)
            return
        }
        self.showIndicationSpinner()
        userAuth.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            self!.removeIndicationSpinner()
            guard error == nil else {
                AlertMaker.shared.basicAlert(on: self!, title: "Error", message: error!.localizedDescription, okFunc: nil)
                return
            }
            
            let changeRequest = self!.userAuth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self!.usernameTextField.text
            changeRequest?.commitChanges { error in
                guard error == nil else {
                    AlertMaker.shared.basicAlert(on: self!, title: "Error", message: error!.localizedDescription, okFunc: nil)
                    return
                }
            }
            
            let userInfoDictionary = [
                "uid": authResult!.user.uid,
                "email": self!.emailTextField.text!,
                "username": self!.usernameTextField.text!,
            ]as [String: Any]
            
            self!.fireStore.collection("User_Infos").document((authResult?.user.uid)!).setData(userInfoDictionary){ [weak self] (error) in
                guard error == nil else {
                    AlertMaker.shared.basicAlert(on: self!, title: "Error", message: error!.localizedDescription, okFunc: nil)
                    return
                }
            }
            
            let userInfo : User = User(id: (authResult?.user.uid)!,
                                       name: self!.usernameTextField.text!,
                                       email: (authResult?.user.email)!)
            
            if let data = try? PropertyListEncoder().encode(userInfo) {
                UserDefaults.standard.set(data, forKey: "currentUserInfo")
            }
            
            AlertMaker.shared.basicAlert(on: self!, title: "Success", message: "User created!", okFunc: {_ in
                if Auth.auth().currentUser != nil {
                    let tabBar = TabBarViewController()
                    tabBar.modalTransitionStyle = .coverVertical
                    tabBar.modalPresentationStyle = .fullScreen
                    self!.present(tabBar, animated: true)
                }
            })
        }
    }
    
    // MARK: - Forgot Password Button Action
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let alert = UIAlertController(title: "Password Reset", message: "Please input you email.", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField { UITextField in
            UITextField.placeholder = "User Email"
        }
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { UIAlertAction in
            self.showIndicationSpinner()
            Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { err in
                self.removeIndicationSpinner()
                if err != nil{
                    AlertMaker.shared.basicAlert(on: self, title: "⚠️ Error", message: err?.localizedDescription ?? "Failure.", okFunc: nil)
                }else {
                    AlertMaker.shared.basicAlert(on: self, title: "Success", message: "Please check your email for further steps.", okFunc: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    //MARK: - Onboarding
    func onboarding() {
        UserDefaults.standard.set(true, forKey: "isOnboardingShown")
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.hidesBottomBarWhenPushed = true
        onboardingViewController.navigationItem.setHidesBackButton(true, animated: false)
        onboardingViewController.modalPresentationStyle = .formSheet
        self.present(onboardingViewController, animated: true)
    }
    
    // MARK: - Hide Keyboard
    @objc func hideKeyb(){
        view.endEditing(true)
    }
}
