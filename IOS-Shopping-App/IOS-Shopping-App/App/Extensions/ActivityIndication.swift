//
//  ActivityIndication.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 6.11.2022.
//

import UIKit

var aView : UIView?

extension UIViewController {
    
    //MARK: - Show Indication
    func showIndicationSpinner() {
        aView = UIView(frame: self.view.frame)
        aView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.95)
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        // Timeout
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { _ in
            self.removeIndicationSpinner()
        }
    }
    
    //MARK: - Remove Indication
    func removeIndicationSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
