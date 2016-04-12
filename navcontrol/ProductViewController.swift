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
    var companySelected  : Company = Company()
    var inEditing = 0
    var reusableCell = "productCell"
    var urlToSend : String = ""
    var newProduct : Product = Product()
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        
        self.title = companySelected.name
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
        
        let itemToMove = companySelected.products[sourceIndexPath.row]
        companySelected.products.removeAtIndex(sourceIndexPath.row)
        companySelected.products.insert(itemToMove, atIndex: destinationIndexPath.row)

    }

    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        companySelected.products.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return (companySelected.products.count)
   
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        
        cell.textLabel?.text = companySelected.products[indexPath.row].name
        cell.imageView?.image = resizeImage(UIImage(named: companySelected.products[indexPath.row].image)!, newWidth: 35.0)
        
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
        urlToSend = companySelected.products[indexPath.row].url
        performSegueWithIdentifier("webViewSegue", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "webViewSegue" {
            let destinationVC = segue.destinationViewController as! WebViewController
            destinationVC.urlString = urlToSend
        }


        
    }
    
    @IBAction func unwindProductCancel(sender:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func unwindProductSave(sender:UIStoryboardSegue) {
        
        let sourceViewController = sender.sourceViewController as! AddEditProduct
        newProduct = sourceViewController.newProduct
        
        companySelected.products += [newProduct]
        
        let newIndexPath = NSIndexPath(forItem: companySelected.products.count - 1, inSection: 0)
        productTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        
    }

    
    

    
}
