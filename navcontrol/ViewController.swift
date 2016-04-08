//
//  ViewController.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/6/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var productTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    var companySelected : Int = 0
    var inEdit = 0
    
    
    var companies = ["Apple", "Samsung","Warby Parker","Sticker Mule"]
    let textCellIdentifier = "reuseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        productTableView.delegate = self
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back Cos", style: .Plain , target: nil, action: nil)
       
    }
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        if inEdit == 0 {
            productTableView.setEditing(true, animated: true)
            editButton.title = "Done"
            inEdit = 1
        }
        else {
            productTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
            inEdit = 0
        }
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
        cell.imageView?.image = UIImage(named: companies[indexPath.row].lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png")
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        companySelected = indexPath.row
        performSegueWithIdentifier("productViewControllerSegue", sender: self)
       
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let destinationVC = segue.destinationViewController as! ProductViewController
        destinationVC.companySelected = companySelected
        
    }


}

