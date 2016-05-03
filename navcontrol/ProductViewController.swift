//
//  CompanyProducts.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/6/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class ProductViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    @IBOutlet var editButton: UIBarButtonItem!
    
    @IBOutlet var productCollectionView: UICollectionView!
    @IBOutlet var productTableView: UITableView!

    weak var companySelected  : Company?
    var reusableCell = "productCell"
    var inEdit = 0
    var urlToSend : String = ""
    weak var newProduct : Product?
    let dataObject : DAO = DAO.sharedInstance
    var undoButton : UIBarButtonItem!
    var undoButtonShown : Bool = false
    
    var longPressGestureRecognizerArray : [UILongPressGestureRecognizer] = []
    var selectedProduct = NSIndexPath()
    var editMode : Bool = false
    var insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewWillAppear(animated: Bool) {
        if editMode == true {
            editButton.title = "Done"
        }
        else {
            editButton.title = "Edit"
        }
    }

    
    override func viewDidLoad() {
        //productTableView.dataSource = self
        //productTableView.delegate = self
        //roductTableView.allowsSelectionDuringEditing = true
        self.title = companySelected!.name
        undoButton = UIBarButtonItem(title: "Undo", style: .Plain, target: self, action: #selector(undoButtonPressed))
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        
        
    }
    
    func undoButtonPressed() {
        dataObject.undoProducts()
        
        productCollectionView.performBatchUpdates(
            {() in
                let sectionIndex = NSIndexSet(index: 0)
                self.productCollectionView.reloadSections(sectionIndex)
            }, completion: nil)

        //productCollectionView.reloadData()
        checkUndoButtonIsShown()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (companySelected?.products.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCellWithReuseIdentifier(reusableCell, forIndexPath: indexPath) as! ProductCollectionCell
        cell.nameLabel.text = companySelected?.products[indexPath.row].name
        cell.imageView.image = Utility.resizeImage(UIImage(named:(companySelected?.products[indexPath.row].image)!)!, newWidth: 100.0)
        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 3.0
        cell.layer.cornerRadius = 5.0
        
        longPressGestureRecognizerArray.append(UILongPressGestureRecognizer(target: self, action: #selector(ProductViewController.longPressGestureProduct)))
        longPressGestureRecognizerArray[indexPath.row].minimumPressDuration = 0.3
        cell.addGestureRecognizer(longPressGestureRecognizerArray[indexPath.row])
        
        return cell

        
    }
    
    func longPressGestureProduct(longPressGesture : UILongPressGestureRecognizer) {
        
        //for longPressGesture in longPressGestureRecognizerArray {
            
            if editMode == false {
                if longPressGesture.state == .Began {
                    let gestureLocation = longPressGesture.locationInView(productCollectionView)
                    let indexPath = productCollectionView.indexPathForItemAtPoint(gestureLocation)
                    
                    let alertController = UIAlertController(title: nil , message: nil, preferredStyle: .ActionSheet)
                    let editAction = UIAlertAction(title: "Edit Product", style: .Default, handler: { (action: UIAlertAction!) in
                        self.newProduct = self.companySelected?.products[indexPath!.row]
                        self.inEdit = 1
                        self.performSegueWithIdentifier("AddEditProductSegue", sender: self)
                    })
                    let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {(action: UIAlertAction!) in
                        self.dataObject.deleteProduct(self.companySelected!, index: indexPath!.row)
                        self.productCollectionView.deleteItemsAtIndexPaths([indexPath!])
                        self.checkUndoButtonIsShown()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    
                    alertController.addAction(editAction)
                    alertController.addAction(deleteAction)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            else {
                let gestureLocation = longPressGesture.locationInView(productCollectionView)
                let indexPath = productCollectionView.indexPathForItemAtPoint(gestureLocation)

                switch(longPressGesture.state) {
                    
                    case UIGestureRecognizerState.Began:
                        UIView.animateWithDuration(0.1, animations: {() in
                        self.productCollectionView.cellForItemAtIndexPath(indexPath!)?.transform = CGAffineTransformScale((self.productCollectionView.cellForItemAtIndexPath(indexPath!)?.transform)!, 1.1, 1.1)
                            })
                        productCollectionView.beginInteractiveMovementForItemAtIndexPath(indexPath!)
                    
                    case UIGestureRecognizerState.Changed:
                        //let touchLocation = longPressGesture.locationInView(longPressGesture.view)
//                        let currentCell = productCollectionView.cellForItemAtIndexPath(indexPath!) as! ProductCollectionCell
//                        let touchLocation = currentCell.currentPoint
                        productCollectionView.updateInteractiveMovementTargetPosition(longPressGesture.locationInView(self.view))
                    
                        
                        //touchLocation = self.view.convertPointFromView(touchLocation)
                    

                    case UIGestureRecognizerState.Ended:
                        if let _ = indexPath {
                            UIView.animateWithDuration(0.1, animations: {() in
                                self.productCollectionView.cellForItemAtIndexPath(indexPath!)?.transform = CGAffineTransformIdentity
                            })
                        }
                        productCollectionView.endInteractiveMovement()
                    
                    default:
                        productCollectionView.cancelInteractiveMovement()
                }
                
                
            }
        //}
        
        
    }
    
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = companySelected!.products[sourceIndexPath.row]
        companySelected!.products.removeAtIndex(sourceIndexPath.row)
        companySelected!.products.insert(itemToMove, atIndex: destinationIndexPath.row)
        updateRowPositions()
        checkUndoButtonIsShown()
        
    }
    
    func didLongPressGesture(longPressGesture : UILongPressGestureRecognizer) {
        
        if longPressGesture.state == .Began {
            let gestureLocation = longPressGesture.locationInView(productTableView)
            if let indexPath = productTableView.indexPathForRowAtPoint(gestureLocation) {
                newProduct = companySelected!.products[indexPath.row]
                inEdit = 1
                performSegueWithIdentifier("AddEditProductSegue", sender: self)
            }
        }
    }

    
    

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        urlToSend = companySelected!.products[indexPath.row].url
        performSegueWithIdentifier("webViewSegue", sender: self)
    }
    
    
    func checkUndoButtonIsShown() {
        if dataObject.canUndo() == true  {
            navigationItem.rightBarButtonItem = undoButton
        }
        else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if editMode == false {
            editMode = true
            editButton.title = "Done"
            
//            productTableView.setEditing(true, animated: true)
//            self.navigationItem.rightBarButtonItem?.title = "Done"
//            if undoButtonShown == true {
//                navigationItem.rightBarButtonItems?.removeAtIndex(1)
//            }

        }
        else {
            editMode = false
            editButton.title = "Edit"
            
//            productTableView.setEditing(false, animated: true)
//            self.navigationItem.rightBarButtonItem?.title = "Edit"
//            if undoButtonShown == true {
//                navigationItem.rightBarButtonItems?.insert(undoButton, atIndex: 1)
//            }
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        let itemToMove = companySelected!.products[sourceIndexPath.row]
        companySelected!.products.removeAtIndex(sourceIndexPath.row)
        companySelected!.products.insert(itemToMove, atIndex: destinationIndexPath.row)
        //checkUndoButtonIsShown()
        undoButtonShown = true
        updateRowPositions()
    }

    func updateRowPositions() {
        for count in 0 ..< companySelected!.products.count {
            companySelected!.products[count].position = count
            dataObject.updateProduct(companySelected!.products[count])
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataObject.deleteProduct(companySelected!, index: indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        updateRowPositions()
        if productTableView.editing == false {
            checkUndoButtonIsShown()
        }
        else {
            undoButtonShown = true
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return (companySelected!.products.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier(reusableCell, forIndexPath: indexPath)
        cell.textLabel?.text = companySelected!.products[indexPath.row].name
        cell.imageView?.image = Utility.resizeImage(UIImage(named: companySelected!.products[indexPath.row].image)!, newWidth: 35.0)
        cell.showsReorderControl = true
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ProductViewController.didLongPressGesture(_:)))
        pressGestureRecognizer.minimumPressDuration = 0.5
        cell.addGestureRecognizer(pressGestureRecognizer)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView.editing == false {
            urlToSend = companySelected!.products[indexPath.row].url
            performSegueWithIdentifier("webViewSegue", sender: self)
        }
        else {
            newProduct = companySelected!.products[indexPath.row]
            performSegueWithIdentifier("AddEditProductSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "webViewSegue" {
            let destinationVC = segue.destinationViewController as! WebViewController
            destinationVC.urlString = urlToSend
            inEdit = 0
        }
        else if segue.identifier == "AddEditProductSegue" {
            let destinationVC = segue.destinationViewController as! UINavigationController
            let destinationB = destinationVC.topViewController as! AddEditProduct
            destinationB.newProduct = newProduct
            destinationB.inEditing = inEdit
            
            if inEdit == 0 {
                //productTableView.editing = false
            }
        }
    }
    
    @IBAction func unwindProductCancel(sender:UIStoryboardSegue) {
//        if inEdit == 1 && productTableView.editing == false {
//            inEdit = 0
//        }
    }
    
    @IBAction func unwindProductSave(sender:UIStoryboardSegue) {
        
        let sourceViewController = sender.sourceViewController as! AddEditProduct
        newProduct = sourceViewController.newProduct!
        
        if inEdit == 0 {
            newProduct!.companyID = companySelected!.id
            newProduct!.position = companySelected!.products.count
            dataObject.addProduct(newProduct!, companySelected: companySelected!)
            let newIndexPath = NSIndexPath(forItem: companySelected!.products.count - 1, inSection: 0)
            productCollectionView.insertItemsAtIndexPaths([newIndexPath])
            checkUndoButtonIsShown()
        }
        else {
            dataObject.updateProduct(newProduct!)
            inEdit = 0
            //editButton.title = "Edit"
            productCollectionView.reloadData()
            checkUndoButtonIsShown()
        }
    }
}
