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
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var logoImageView: UIImageView!

    let textCellIdentifier = "reuseCell"
    var companySelected : Company = Company()
    var companies : [Company] = []
    var newCompany : Company = Company()
    var inEdit = 0
    var longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    override func viewWillAppear(animated: Bool) {
        getStockPrice(companies, companyTableView: companyTableView)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self
        self.navigationController?.toolbarHidden = false

        companyTableView.allowsSelectionDuringEditing = true
        
        let dataObject : DataStore = DataStore.sharedInstance
        companies = dataObject.getCompanies()
        
        
        
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if companyTableView.editing == false {
            companyTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            inEdit = 1
            companyTableView.reloadData()
//            let range = NSMakeRange(0, self.companyTableView.numberOfSections)
//            let sections = NSIndexSet(indexesInRange: range)
//            self.companyTableView.reloadSections(sections, withRowAnimation: .None)
            
        }
        else {
            companyTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            inEdit = 0
            companyTableView.reloadData()
//            let range = NSMakeRange(0, self.companyTableView.numberOfSections)
//            let sections = NSIndexSet(indexesInRange: range)
//            self.companyTableView.reloadSections(sections, withRowAnimation: .Fade)
            
            

            
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
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! CompanyTableViewCell
        //cell.textLabel?.text = companies[indexPath.row].name
        //cell.imageView?.image = resizeImage(UIImage(named: companies[indexPath.row].image)!, newWidth: 100.0)
        cell.showsReorderControl = false
        
        cell.companyNameLabel.text = companies[indexPath.row].name
        cell.logoImageView.image = resizeImage(UIImage(named: companies[indexPath.row].image)!, newWidth: 100.0)
        
        if companies[indexPath.row].stockPrice == "" {
            cell.stockSymbolLabel.text = "Private"
            cell.stockPriceLabel.text = ""
        }
        else {
            cell.stockSymbolLabel.text = companies[indexPath.row].stock
            cell.stockPriceLabel.text = String(companies[indexPath.row].stockPrice)
        }
        
        
        if companyTableView.editing == true {
            cell.leadingImageViewConstraint.constant = 40.0
        }
        else  {
            cell.leadingImageViewConstraint.constant = 0.0
        }
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.didLongPressGesture) )
        longPressGesture.minimumPressDuration = 0.5
        cell.showsReorderControl = true
        cell.addGestureRecognizer(longPressGesture)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
//        return 1
//    }

   
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        companySelected = companies[indexPath.row]
        if tableView.editing == false {
            performSegueWithIdentifier("productViewControllerSegue", sender:indexPath)
        }
        else if tableView.editing == true {
            performSegueWithIdentifier("addEditCompanySegue", sender:self)
        }

    }
    
    func didLongPressGesture(longPressGesture : UILongPressGestureRecognizer) {
        if longPressGesture.state == .Began {
            let pressLocation = longPressGesture.locationInView(companyTableView)
            if let pressedIndexPath = companyTableView.indexPathForRowAtPoint(pressLocation) {
                    companySelected = companies[pressedIndexPath.row]
                    inEdit = 1
                    performSegueWithIdentifier("addEditCompanySegue", sender:self)
            }
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productViewControllerSegue" {
            let destViewController = segue.destinationViewController as! ProductViewController
            destViewController.companySelected = companySelected
        }
        else if segue.identifier == "addEditCompanySegue" {
            let destViewController = segue.destinationViewController as! UINavigationController
            let destinationB = destViewController.topViewController as! AddEditCompany
            destinationB.company = companySelected
            destinationB.editExisting = inEdit
        }

    }
    
    @IBAction func unwindCancel(sender: UIStoryboardSegue) {
        if inEdit==1 && companyTableView.editing == false {
            inEdit = 0
        }
    }
    
    
    @IBAction func unwindSave(sender: UIStoryboardSegue) {
        
        let sourceViewController = sender.sourceViewController as! AddEditCompany
        
        if inEdit == 0 {
            newCompany = sourceViewController.company
            companies += [newCompany]
            getStockPrice(companies, companyTableView: companyTableView)
            let newPath = NSIndexPath(forItem: companies.count - 1, inSection: 0)
            companyTableView.insertRowsAtIndexPaths([newPath], withRowAnimation: .Bottom)
        }
        else {
            getStockPrice(companies, companyTableView: companyTableView)
            companyTableView.editing = false
            editButton.title = "Edit"
            inEdit = 0
            companyTableView.reloadData()
            
        }

    }
    

}

