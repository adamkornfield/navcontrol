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
    var companySelected : Int = 0
    
    
    let companies = ["Apple", "Samsung","Warby Parker","Sticker Mule"]
    let textCellIdentifier = "reuseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        productTableView.delegate = self
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back Cos", style: .Plain , target: nil, action: nil)
       
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

