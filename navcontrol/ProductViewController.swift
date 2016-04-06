//
//  CompanyProducts.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/6/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class ProductViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var productTableView: UITableView!
    var deviceMakerSelected : Int = 0
    var reusableCell = "productCell"
    
    let appleProducts = ["iPad","iPhone","MacBook Air","Apple Watch"]
    let samsungProducts = ["Galaxy", "Galaxy Tab","Galaxy Note"]
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if deviceMakerSelected == 0 {
            self.title = "Apple Products"
            return appleProducts.count
            
        }
        else {
            self.title = "Samsung Products"
            return samsungProducts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        
        if deviceMakerSelected == 0 {
            cell.textLabel?.text = appleProducts[indexPath.row]
        }
        else {
            cell.textLabel?.text = samsungProducts[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
