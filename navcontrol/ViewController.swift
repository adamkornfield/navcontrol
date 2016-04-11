//
//  ViewController.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/6/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var companyTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var companySelected  = ""
    var inEdit = 0
    var companies = ["Apple", "Samsung","Warby Parker","Sticker Mule"]
    
    var appleProducts:[String] =  ["iPad", "iPhone", "MacBook Air","Apple Watch"]
    var samsungProducts:[String] = ["Galaxy", "Galaxy Note","Gear"]
    var warbyParkerProducts:[String] = ["Henry","Crane","Eaton"]
    var stickerMuleProducts:[String] = ["Die Cut","Rectangle","Circle"]
    
    var appleProds : CompanyProducts?
    var samsungProds : CompanyProducts?
    var warbyParkerProds : CompanyProducts?
    var stickerMuleProds : CompanyProducts?
    
    
    let textCellIdentifier = "reuseCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self
        
        appleProds = CompanyProducts(inProducts: appleProducts)
        samsungProds = CompanyProducts(inProducts: samsungProducts)
        warbyParkerProds = CompanyProducts(inProducts: warbyParkerProducts)
        stickerMuleProds = CompanyProducts(inProducts: stickerMuleProducts)
        
        
    }
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if inEdit == 0 {
            companyTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            inEdit = 1
        }
        else {
            companyTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            inEdit = 0
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let itemToMove = companies[sourceIndexPath.row]
        companies.removeAtIndex(sourceIndexPath.row)
        companies.insert(itemToMove, atIndex: destinationIndexPath.row)

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            companies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = companies[indexPath.row]
        cell.imageView?.image = resizeImage(UIImage(named: companies[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")!, newWidth: 100.0)
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
        companySelected = companies[indexPath.row]
        performSegueWithIdentifier("productViewControllerSegue", sender:indexPath)
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destViewController = segue.destinationViewController as! ProductViewController
        destViewController.companySelected = companySelected
        switch companySelected {
        case "Apple": destViewController.companyProducts = appleProds
            case "Samsung": destViewController.companyProducts = samsungProds
            case "Warby Parker": destViewController.companyProducts = warbyParkerProds
            case "Sticker Mule": destViewController.companyProducts = stickerMuleProds
            default: self.title = "Products"
        }

    }
    



}

