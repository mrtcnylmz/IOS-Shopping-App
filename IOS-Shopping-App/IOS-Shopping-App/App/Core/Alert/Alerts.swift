//
//  Alerts.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 4.11.2022.
//

import Foundation
import UIKit

final class AlertMaker{
    
    static let shared = AlertMaker()
    
    //MARK: BasicAlert
    func basicAlert(`on` controller: UIViewController, title : String, message : String, okFunc : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: okFunc)
        alert.addAction(okAction)
        controller.present(alert, animated: true)
    }
    
    //MARK: BasicCancelAlert
    func basicCancelAlert(`on` controller: UIViewController, title : String, message : String, okFunc : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: okFunc)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        controller.present(alert, animated: true)
    }
}
