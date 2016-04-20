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
    var reusableCell = "productCell"
    var inEdit = 0
    var urlToSend : String = ""
    var newProduct : Product = Product()
    let dataObject : DataStore = DataStore.sharedInstance
    
    
    override func viewDidLoad() {
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.allowsSelectionDuringEditing = true
        self.title = companySelected.name
    }
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        
        if productTableView.editing == false {
            productTableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Done"
            inEdit = 1
        }
        else {
            productTableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "Edit"
            inEdit = 0
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let itemToMove = companySelected.products[sourceIndexPath.row]
        companySelected.products.removeAtIndex(sourceIndexPath.row)
        companySelected.products.insert(itemToMove, atIndex: destinationIndexPath.row)
        updateRowPositions()

    }

    func updateRowPositions() {
        
        for count in 0 ..< companySelected.products.count {
            companySelected.products[count].position = count
            dataObject.updateProduct(companySelected.products[count])
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        dataObject.deleteProduct(companySelected, index: indexPath.row)
        //companySelected.products.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        updateRowPositions()
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
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ProductViewController.didLongPressGesture(_:)))
        pressGestureRecognizer.minimumPressDuration = 0.5
        cell.addGestureRecognizer(pressGestureRecognizer)
        
        return cell
    }
    
    
    func didLongPressGesture(longPressGesture : UILongPressGestureRecognizer) {
        
        if longPressGesture.state == .Began {
            let gestureLocation = longPressGesture.locationInView(productTableView)
            if let indexPath = productTableView.indexPathForRowAtPoint(gestureLocation) {
                newProduct = companySelected.products[indexPath.row]
                inEdit = 1
                performSegueWithIdentifier("AddEditProductSegue", sender: self)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.editing == false {
            urlToSend = companySelected.products[indexPath.row].url
            performSegueWithIdentifier("webViewSegue", sender: self)
        }
        else {
            newProduct = companySelected.products[indexPath.row]
            performSegueWithIdentifier("AddEditProductSegue", sender: self)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "webViewSegue" {
            let destinationVC = segue.destinationViewController as! WebViewController
            destinationVC.urlString = urlToSend
        }
        else if segue.identifier == "AddEditProductSegue" {
            let destinationVC = segue.destinationViewController as! UINavigationController
            let destinationB = destinationVC.topViewController as! AddEditProduct
            destinationB.newProduct = newProduct
            destinationB.inEditing = inEdit
            if inEdit == 0 {
                productTableView.editing = false
            }
        }


        
    }
    
    @IBAction func unwindProductCancel(sender:UIStoryboardSegue) {
        if inEdit == 1 && productTableView.editing == false {
            inEdit = 0
        }
    }
    
    
    @IBAction func unwindProductSave(sender:UIStoryboardSegue) {
        
        let sourceViewController = sender.sourceViewController as! AddEditProduct
        newProduct = sourceViewController.newProduct
        
        if inEdit == 0 {
            newProduct.companyID = companySelected.id
            newProduct.position = companySelected.products.count
            //companySelected.products += [newProduct]
            dataObject.addProduct(newProduct, companySelected: companySelected)
            let newIndexPath = NSIndexPath(forItem: companySelected.products.count - 1, inSection: 0)
            productTableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        else {
            dataObject.updateProduct(newProduct)
            inEdit = 0
            productTableView.editing = false
            editButton.title = "Edit"
            productTableView.reloadData()
        }
    }

    
    

    
}
