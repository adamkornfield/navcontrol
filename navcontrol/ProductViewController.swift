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
    @IBOutlet var editButton: UIBarButtonItem!
    var companySelected  = ""
    var companyProducts : CompanyProducts?
    var inEditing = 0
    
    var reusableCell = "productCell"
    
    

    
    
    let appleProductLinks : [String:String] = ["iPad" : "http://www.apple.com/ipad/","iPhone" : "http://www.apple.com/iphone/","MacBook Air" : "http://www.apple.com/macbook-air/","Apple Watch" : "http://www.apple.com/watch/"]
    let samsungProductLinks = ["Galaxy" : "https://www.samsung.com/us/mobile/cell-phones/SM-G935AZDAATT", "Galaxy Note" : "http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT","Gear" : "http://www.samsung.com/us/mobile/wearable-tech/SM-R7200ZWAXAR"]
    let warbyParkerProductLinks = ["Henry" : "https://www.warbyparker.com/eyeglasses/men/henry/port-blue","Crane" : "https://www.warbyparker.com/eyeglasses/men/crane/atlantic-blue","Eaton" : "https://www.warbyparker.com/eyeglasses/men/eaton/tree-swallow-fade"]
    let stickerMuleProductLinks = ["Die Cut" : "https://www.stickermule.com/products/die-cut-stickers","Rectangle" : "https://www.stickermule.com/products/rectangle-stickers","Circle" : "https://www.stickermule.com/products/circle-stickers"]
    
    var urlToSend : String = ""
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        
        self.title = companySelected

        


        
    }
    @IBAction func editButtonPressed(sender: AnyObject) {
        
        if inEditing == 0 {
            productTableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
            inEditing = 1
        }
        else {
            productTableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            inEditing = 0

        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let itemToMove = companyProducts?.products[sourceIndexPath.row]
        companyProducts?.products.removeAtIndex(sourceIndexPath.row)
        companyProducts?.products.insert(itemToMove!, atIndex: destinationIndexPath.row)
        
        

    }
    

    
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        companyProducts?.products.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return (companyProducts?.products.count)!
   
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        
        switch companySelected {
            case "Apple": cell.textLabel?.text = companyProducts?.products[indexPath.row]
                    cell.imageView?.image = resizeImage(UIImage(named: (companyProducts?.products[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: ""))! + ".png")!, newWidth: 37.0)
            case "Samsung": cell.textLabel?.text = companyProducts?.products[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: (companyProducts?.products[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: ""))! + ".png")!, newWidth: 31.0)
            case "Warby Parker": cell.textLabel?.text = companyProducts?.products[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: (companyProducts?.products[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: ""))! + ".png")!, newWidth: 100.0)
            case "Sticker Mule": cell.textLabel?.text = companyProducts?.products[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: (companyProducts?.products[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: ""))! + ".png")!, newWidth: 40.0)
            default: break
        }

        cell.showsReorderControl = true
        
        return cell
    }
    
    
    func resizeImage(image:UIImage, newWidth: CGFloat) -> UIImage {
        
        let newScale = newWidth/image.size.width
        let newHeight = newScale * image.size.height
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
        let theNewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return theNewImage
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
   

        
        switch companySelected {
            case "Apple": urlToSend = appleProductLinks[(companyProducts?.products[indexPath.row])!]!
            case "Samsung": urlToSend = samsungProductLinks[(companyProducts?.products[indexPath.row])!]!
            case "Warby Parker": urlToSend = warbyParkerProductLinks[(companyProducts?.products[indexPath.row])!]!
            case "Sticker Mule": urlToSend = stickerMuleProductLinks[(companyProducts?.products[indexPath.row])!]!
            default: urlToSend = "http://google.com"
        }

        
        performSegueWithIdentifier("webViewSegue", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "webViewSegue" {
            let destinationVC = segue.destinationViewController as! WebViewController
            destinationVC.urlString = urlToSend
        }


        
    }

    

    
}
