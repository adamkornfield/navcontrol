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
    var companySelected : Int = 0
    
    var reusableCell = "productCell"
    
    let appleProducts = ["iPad","iPhone","MacBook Air","Apple Watch"]
    let samsungProducts = ["Galaxy", "Galaxy Tab","Galaxy Note"]
    let warbyParkerProducts = ["Henry","Crane","Haskell"]
    let stickerMuleProducts = ["Die Cut","Rectangle","Circle"]
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        
        switch companySelected {
            case 0: self.title = "Apple"
            case 1: self.title = "Samsung"
            case 2: self.title = "Warby Parker"
            case 3: self.title = "Sticker Mule"
            default: self.title = "Products"
        }

        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch companySelected {
            case 0: return appleProducts.count
            case 1: return samsungProducts.count
            case 2: return warbyParkerProducts.count
            case 3: return stickerMuleProducts.count
            default: return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        
        switch companySelected {
            case 0: cell.textLabel?.text = appleProducts[indexPath.row]
            case 1: cell.textLabel?.text = samsungProducts[indexPath.row]
            case 2: cell.textLabel?.text = warbyParkerProducts[indexPath.row]
            case 3: cell.textLabel?.text = stickerMuleProducts[indexPath.row]
            default: break
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
