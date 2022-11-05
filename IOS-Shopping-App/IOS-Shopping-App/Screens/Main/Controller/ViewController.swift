//
//  ViewController.swift
//  IOS-Shopping-App
//
//  Created by Mertcan Yılmaz on 2.11.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var productListViewModel : ProductListViewModel?{
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var prod : [Product]?{
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
        
        //getData()

        
        
    }
    
    func getData() {
        StoreAPI.shared.fetchProducts { products, error in
            if let products = products {
                self.productListViewModel = ProductListViewModel(productList: products)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productListViewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celly", for: indexPath)
        let productViewModel = self.productListViewModel!.productAtIndex(indexPath.row)
        
        cell.textLabel?.text = productViewModel.name
        cell.backgroundColor = .gray
        return cell
    }
    
    @IBAction func buttonclick(_ sender: Any) {
        //let myVC = ViewController(nibName:"AuthViewController", bundle:nil)
        //self.navigationController?.pushViewController(myVC, animated: true);
        self.navigationController!.pushViewController(AuthViewController(), animated: true );
        
    }
}

