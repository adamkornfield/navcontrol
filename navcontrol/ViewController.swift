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

    var inEdit = 0
    
    let iPad  = Product(inName: "iPad", inURL: "http://www.apple.com/ipad/", inImage: "ipad.png")
    let iPhone = Product(inName: "iPhone", inURL: "http://www.apple.com/iphone/", inImage: "iphone.png")
    let macBookAir = Product(inName: "MacBook Air", inURL: "http://www.apple.com/macbook-air/", inImage: "macbookair.png")
    let appleWatch = Product(inName: "Apple Watch", inURL: "http://www.apple.com/watch/", inImage: "applewatch.png")
    
    let galaxy = Product(inName: "Galaxy", inURL: "https://www.samsung.com/us/mobile/cell-phones/SM-G935AZDAATT", inImage: "galaxy.png")
    let galaxyNote = Product(inName: "Galaxy Note", inURL: "http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT", inImage: "galaxynote.png")
    let gear = Product(inName: "Gear", inURL: "http://www.samsung.com/us/mobile/wearable-tech/SM-R7200ZWAXAR", inImage: "gear.png")
    
    let henry = Product(inName: "Henry", inURL: "https://www.warbyparker.com/eyeglasses/men/henry/port-blue", inImage: "henry.png")
    let crane = Product(inName: "Crane", inURL: "https://www.warbyparker.com/eyeglasses/men/crane/atlantic-blue", inImage: "crane.png")
    let eaton = Product(inName: "Eaton", inURL: "https://www.warbyparker.com/eyeglasses/men/eaton/tree-swallow-fade", inImage: "eaton.png")
    
    let dieCut = Product(inName: "Die Cut", inURL: "https://www.stickermule.com/products/die-cut-stickers", inImage: "diecut.png")
    let rectangle = Product(inName: "Rectangle", inURL: "https://www.stickermule.com/products/rectangle-stickers", inImage: "rectangle")
    let circle = Product(inName: "Circle", inURL: "https://www.stickermule.com/products/circle-stickers", inImage: "circle.png")
    
    var apple : Company = Company()
    var samsung : Company = Company()
    var warbyParker : Company = Company()
    var stickerMule : Company = Company()
    
    
    let textCellIdentifier = "reuseCell"
    var companySelected : Company = Company()
    var companies : [Company] = []
    
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyTableView.dataSource = self
        companyTableView.delegate = self

        
        
        apple = Company(inName: "Apple", inProducts: [iPad,iPhone,macBookAir,appleWatch], inImage: "apple.png")
        samsung = Company(inName: "Samsung", inProducts: [galaxy, galaxyNote, gear], inImage: "samsung.png")
        warbyParker = Company(inName: "Warby Parker", inProducts: [henry,crane,eaton], inImage: "warbyparker.png")
        stickerMule = Company(inName: "Sticker Mule", inProducts: [dieCut, rectangle, circle], inImage: "stickermule.png")

        
        companies += [apple,samsung,warbyParker,stickerMule]

        
        
        
        
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
        cell.textLabel?.text = companies[indexPath.row].name
        cell.imageView?.image = resizeImage(UIImage(named: companies[indexPath.row].image)!, newWidth: 100.0)
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
        switch companySelected.name {
            case "Apple": destViewController.companySelected = apple
            case "Samsung": destViewController.companySelected = samsung
            case "Warby Parker": destViewController.companySelected = warbyParker
            case "Sticker Mule": destViewController.companySelected = stickerMule
            default: break
        }

    }
    



}

