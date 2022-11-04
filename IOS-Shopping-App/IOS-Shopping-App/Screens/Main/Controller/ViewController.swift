//
//  ViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var prod : Product?{
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreAPI.shared.fetchUrl { product, error in
            self.prod = product
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        prod?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celly", for: indexPath)
        cell.textLabel?.text = prod![indexPath.row].id?.description
        cell.backgroundColor = .cyan
        return cell
    }
    
    
    @IBAction func buttonclick(_ sender: Any) {
        //let myVC = ViewController(nibName:"AuthViewController", bundle:nil)
        //self.navigationController?.pushViewController(myVC, animated: true);
        self.navigationController!.pushViewController(AuthViewController(), animated: true );

    }
    
    
}

