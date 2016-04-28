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
    weak var companySelected : Company?
    
    weak var newCompany : Company?
    var inEdit = 0
    var longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    let dataObject : DAO = DAO.sharedInstance
    var undoButton : UIBarButtonItem!
    var undoButtonShown : Bool = false
    var wentToProductViewController : Bool = false
    
    
    override func viewWillAppear(animated: Bool) {
        if dataObject.companies.count > 0 {
            Utility.getStockPrice(dataObject.companies, companyTableView: companyTableView)
        }
        
        if wentToProductViewController == true {
            wentToProductViewController = false
            dataObject.clearUndos()
            checkUndoButtonIsShown()
            undoButtonShown = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self
        self.navigationController?.toolbarHidden = false
        companyTableView.allowsSelectionDuringEditing = true
        undoButton = UIBarButtonItem(title: "Undo", style: .Plain, target: self, action: #selector(undoButtonPressed))
    }
    
    func undoButtonPressed() {
        dataObject.undoCompaniesAndProducts()
        Utility.getStockPrice(dataObject.companies, companyTableView: companyTableView)
        companyTableView.reloadData()
        checkUndoButtonIsShown()
    }

    func checkUndoButtonIsShown() {
        if dataObject.canUndo() == true  {
            if undoButtonShown == false {
                navigationItem.rightBarButtonItems?.insert(undoButton, atIndex: 1)
                undoButtonShown = true
            }
        }
        else {
            if undoButtonShown == true {
                navigationItem.rightBarButtonItems?.removeAtIndex(1)
                undoButtonShown = false
            }
        }
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if companyTableView.editing == false {
            companyTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            inEdit = 1
            companyTableView.reloadData()
            if undoButtonShown == true {
                navigationItem.rightBarButtonItems?.removeAtIndex(1)
            }
        }
        else {
            companyTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            inEdit = 0
            companyTableView.reloadData()
            if undoButtonShown == true {
                navigationItem.rightBarButtonItems?.insert(undoButton, atIndex: 1)
            }
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = dataObject.companies[sourceIndexPath.row]
        dataObject.companies.removeAtIndex(sourceIndexPath.row)
        dataObject.companies.insert(itemToMove, atIndex: destinationIndexPath.row)
        //checkUndoButtonIsShown()
        undoButtonShown = true
        updateRowPositions()
    }
    
    func updateRowPositions() {
        for count in 0 ..< dataObject.companies.count {
            dataObject.companies[count].position = count
            dataObject.updateCompany(dataObject.companies[count])
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            dataObject.deleteCompany(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            updateRowPositions()
            if companyTableView.editing == false {
                checkUndoButtonIsShown()
            }
            else {
                undoButtonShown = true
            }
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObject.companies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! CompanyTableViewCell
        cell.showsReorderControl = false
        cell.companyNameLabel.text = dataObject.companies[indexPath.row].name
        cell.logoImageView.image = Utility.resizeImage(UIImage(named: dataObject.companies[indexPath.row].image)!, newWidth: 100.0)
        if dataObject.companies[indexPath.row].stockPrice == "" {
            cell.stockSymbolLabel.text = "Private"
            cell.stockPriceLabel.text = ""
        }
        else {
            cell.stockSymbolLabel.text = dataObject.companies[indexPath.row].stock
            cell.stockPriceLabel.text = String(dataObject.companies[indexPath.row].stockPrice)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        companySelected = dataObject.companies[indexPath.row]
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
                    companySelected = dataObject.companies[pressedIndexPath.row]
                    inEdit = 1
                    performSegueWithIdentifier("addEditCompanySegue", sender:self)
            }
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "productViewControllerSegue" {
            let destViewController = segue.destinationViewController as! ProductViewController
            destViewController.companySelected = companySelected!
            wentToProductViewController = true
            dataObject.clearUndos()
        }
        else if segue.identifier == "addEditCompanySegue" {
            let destViewController = segue.destinationViewController as! UINavigationController
            let destinationB = destViewController.topViewController as! AddEditCompany
            if let _ = companySelected {
                destinationB.company = companySelected!
            }
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
        newCompany = sourceViewController.company
        if inEdit == 0 {
            newCompany!.position = dataObject.companies.count
            dataObject.addCompany(newCompany!)
            Utility.getStockPrice(dataObject.companies, companyTableView: companyTableView)
            let newPath = NSIndexPath(forItem: dataObject.companies.count - 1, inSection: 0)
            companyTableView.insertRowsAtIndexPaths([newPath], withRowAnimation: .Bottom)
        }
        else {
            dataObject.updateCompany(newCompany!)
            Utility.getStockPrice(dataObject.companies, companyTableView: companyTableView)
            companyTableView.editing = false
            editButton.title = "Edit"
            inEdit = 0
            companyTableView.reloadData()
        }
    }
    
}

