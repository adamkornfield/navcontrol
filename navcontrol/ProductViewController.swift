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
    var inEditing = 0
    
    var reusableCell = "productCell"
    
    
    
    var appleProducts  = ["iPad", "iPhone", "MacBook Air","Apple Watch"]
    var samsungProducts = ["Galaxy", "Galaxy Note","Gear"]
    var warbyParkerProducts = ["Henry","Crane","Eaton"]
    var stickerMuleProducts = ["Die Cut","Rectangle","Circle"]
    
    
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
        switch companySelected {
        case "Apple":   let itemToMove = appleProducts[sourceIndexPath.row]
                        appleProducts.removeAtIndex(sourceIndexPath.row)
                        appleProducts.insert(itemToMove, atIndex: destinationIndexPath.row)
        case "Samsung": let itemToMove = samsungProducts[sourceIndexPath.row]
                        samsungProducts.removeAtIndex(sourceIndexPath.row)
                        samsungProducts.insert(itemToMove, atIndex: destinationIndexPath.row)
        case "Warby Parker":    let itemToMove = warbyParkerProducts[sourceIndexPath.row]
                                warbyParkerProducts.removeAtIndex(sourceIndexPath.row)
                                warbyParkerProducts.insert(itemToMove, atIndex: destinationIndexPath.row)
        case "Sticker Mule":    let itemToMove = stickerMuleProducts[sourceIndexPath.row]
                                stickerMuleProducts.removeAtIndex(sourceIndexPath.row)
                                stickerMuleProducts.insert(itemToMove, atIndex: destinationIndexPath.row)
        default: self.title = "Products"
        }

    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch companySelected {
        case "Apple": appleProducts.removeAtIndex(indexPath.row)
        case "Samsung": samsungProducts.removeAtIndex(indexPath.row)
        case "Warby Parker": warbyParkerProducts.removeAtIndex(indexPath.row)
        case "Sticker Mule": stickerMuleProducts.removeAtIndex(indexPath.row)
        default: self.title = "Products"
        }

        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch companySelected {
            case "Apple": return appleProducts.count
            case "Samsung": return samsungProducts.count
            case "Warby Parker": return warbyParkerProducts.count
            case "Sticker Mule": return stickerMuleProducts.count
            default: return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        
        switch companySelected {
            case "Apple": cell.textLabel?.text = appleProducts[indexPath.row]
                    cell.imageView?.image = resizeImage(UIImage(named: appleProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")!, newWidth: 37.0)
            case "Samsung": cell.textLabel?.text = samsungProducts[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: samsungProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")!, newWidth: 31.0)
            case "Warby Parker": cell.textLabel?.text = warbyParkerProducts[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: warbyParkerProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")!, newWidth: 100.0)
            case "Sticker Mule": cell.textLabel?.text = stickerMuleProducts[indexPath.row]
                cell.imageView?.image = resizeImage(UIImage(named: stickerMuleProducts[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")!, newWidth: 40.0)
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
            case "Apple": urlToSend = appleProductLinks[appleProducts[indexPath.row]]!
            case "Samsung": urlToSend = samsungProductLinks[samsungProducts[indexPath.row]]!
            case "Warby Parker": urlToSend = warbyParkerProductLinks[warbyParkerProducts[indexPath.row]]!
            case "Sticker Mule": urlToSend = stickerMuleProductLinks[stickerMuleProducts[indexPath.row]]!
            default: urlToSend = "http://google.com"
        }

        
        performSegueWithIdentifier("webViewSegue", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationVC = segue.destinationViewController as! WebViewController
        destinationVC.urlString = urlToSend
        
    }
    

    
}
