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
    
    
    
    let appleProducts  = ["iPad", "iPhone", "MacBook Air","Apple Watch"]
    let samsungProducts = ["Galaxy", "Galaxy Note","Gear"]
    let warbyParkerProducts = ["Henry","Crane","Eaton"]
    let stickerMuleProducts = ["Die Cut","Rectangle","Circle"]
    
    
    let appleProductLinks : [String:String] = ["iPad" : "http://www.apple.com/ipad/","iPhone" : "http://www.apple.com/iphone/","MacBook Air" : "http://www.apple.com/macbook-air/","Apple Watch" : "http://www.apple.com/watch/"]
    let samsungProductLinks = ["Galaxy" : "https://www.samsung.com/us/mobile/cell-phones/SM-G935AZDAATT", "Galaxy Note" : "http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT","Gear" : "http://www.samsung.com/us/mobile/wearable-tech/SM-R7200ZWAXAR"]
    let warbyParkerProductLinks = ["Henry" : "https://www.warbyparker.com/eyeglasses/men/henry/port-blue","Crane" : "https://www.warbyparker.com/eyeglasses/men/crane/atlantic-blue","Eaton" : "https://www.warbyparker.com/eyeglasses/men/eaton/tree-swallow-fade"]
    let stickerMuleProductLinks = ["Die Cut" : "https://www.stickermule.com/products/die-cut-stickers","Rectangle" : "https://www.stickermule.com/products/rectangle-stickers","Circle" : "https://www.stickermule.com/products/circle-stickers"]
    
    var urlToSend : String = ""
    
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
                    cell.imageView?.image = UIImage(named: appleProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")
            case 1: cell.textLabel?.text = samsungProducts[indexPath.row]
                cell.imageView?.image = UIImage(named: samsungProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")
            case 2: cell.textLabel?.text = warbyParkerProducts[indexPath.row]
                cell.imageView?.image = UIImage(named: warbyParkerProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")
            case 3: cell.textLabel?.text = stickerMuleProducts[indexPath.row]
                cell.imageView?.image = UIImage(named: stickerMuleProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")
            default: break
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
   

        
        switch companySelected {
            case 0: urlToSend = appleProductLinks[appleProducts[indexPath.row]]!
            case 1: urlToSend = samsungProductLinks[samsungProducts[indexPath.row]]!
            case 2: urlToSend = warbyParkerProductLinks[warbyParkerProducts[indexPath.row]]!
            case 3: urlToSend = stickerMuleProductLinks[stickerMuleProducts[indexPath.row]]!
            default: urlToSend = "http://google.com"
        }

        
        performSegueWithIdentifier("webViewSegue", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! WebViewController
        destinationVC.urlString = urlToSend
        
    }
    

    
}
