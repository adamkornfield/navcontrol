//
//  Seed.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/28/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import CoreData

extension DAO {
    func loadHardCodedValues() {
        let appleEntity = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedContext)
        appleEntity.setValue("Apple", forKey: "name")
        appleEntity.setValue("apple.png", forKey: "image")
        appleEntity.setValue("AAPL", forKey: "stock")
        appleEntity.setValue(0 , forKey: "position")
        appleEntity.setValue(0, forKey: "id")
        
        let samsungEntity = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedContext)
        samsungEntity.setValue("Samsung", forKey: "name")
        samsungEntity.setValue("samsung.png", forKey: "image")
        samsungEntity.setValue("005930.KS", forKey: "stock")
        samsungEntity.setValue(1, forKey: "position")
        samsungEntity.setValue(1, forKey: "id")
        
        let warbyParkerEntity = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedContext)
        warbyParkerEntity.setValue("Warby Parker", forKey: "name")
        warbyParkerEntity.setValue("warbyparker.png", forKey: "image")
        warbyParkerEntity.setValue("", forKey: "stock")
        warbyParkerEntity.setValue(2 , forKey: "position")
        warbyParkerEntity.setValue(2, forKey: "id")
        
        let stickerMuleEntity = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedContext)
        stickerMuleEntity.setValue("Sticker Mule", forKey: "name")
        stickerMuleEntity.setValue("stickermule.png", forKey: "image")
        stickerMuleEntity.setValue("", forKey: "stock")
        stickerMuleEntity.setValue(3 , forKey: "position")
        stickerMuleEntity.setValue(3, forKey: "id")
        
        let companyResults = [appleEntity, samsungEntity,warbyParkerEntity,stickerMuleEntity]
        
        for result in companyResults  {
            companies += [Company(inName: result.valueForKey("name") as! String, inProducts: [], inImage: result.valueForKey("image") as! String, inStock: result.valueForKey("stock") as! String, inID: result.valueForKey("id") as! Int, inPosition: result.valueForKey("position") as! Int)]
        }
        
        //Apple products
        let ipadEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        ipadEntity.setValue(0, forKey: "companyID")
        ipadEntity.setValue(0, forKey: "productID")
        ipadEntity.setValue("iPad", forKey: "name")
        ipadEntity.setValue("ipad.png", forKey: "image")
        ipadEntity.setValue("http://www.apple.com/ipad/", forKey: "url")
        ipadEntity.setValue(0, forKey: "position")
        
        let iphoneEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        iphoneEntity.setValue(0, forKey: "companyID")
        iphoneEntity.setValue(1, forKey: "productID")
        iphoneEntity.setValue("iPhone", forKey: "name")
        iphoneEntity.setValue("iphone.png", forKey: "image")
        iphoneEntity.setValue("http://www.apple.com/iphone/", forKey: "url")
        iphoneEntity.setValue(1, forKey: "position")
        
        let macbookairEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        macbookairEntity.setValue(0, forKey: "companyID")
        macbookairEntity.setValue(2, forKey: "productID")
        macbookairEntity.setValue("MacBook Air", forKey: "name")
        macbookairEntity.setValue("macbookair.png", forKey: "image")
        macbookairEntity.setValue("http://www.apple.com/macbook-air/", forKey: "url")
        macbookairEntity.setValue(2, forKey: "position")
        
        let applewatchEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        applewatchEntity.setValue(0, forKey: "companyID")
        applewatchEntity.setValue(3, forKey: "productID")
        applewatchEntity.setValue("Apple Watch", forKey: "name")
        applewatchEntity.setValue("applewatch.png", forKey: "image")
        applewatchEntity.setValue("http://www.apple.com/watch/", forKey: "url")
        applewatchEntity.setValue(3, forKey: "position")
        
        //Samsung Products
        let galaxyEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        galaxyEntity.setValue(1, forKey: "companyID")
        galaxyEntity.setValue(4, forKey: "productID")
        galaxyEntity.setValue("Galaxy", forKey: "name")
        galaxyEntity.setValue("galaxy.png", forKey: "image")
        galaxyEntity.setValue("https://www.samsung.com/us/mobile/cell-phones/SM-G935AZDAATT", forKey: "url")
        galaxyEntity.setValue(0, forKey: "position")
        
        let galaxyNoteEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        galaxyNoteEntity.setValue(1, forKey: "companyID")
        galaxyNoteEntity.setValue(5, forKey: "productID")
        galaxyNoteEntity.setValue("Galaxy Note", forKey: "name")
        galaxyNoteEntity.setValue("galaxynote.png", forKey: "image")
        galaxyNoteEntity.setValue("http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT", forKey: "url")
        galaxyNoteEntity.setValue(1, forKey: "position")
        
        let gearEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        gearEntity.setValue(1, forKey: "companyID")
        gearEntity.setValue(6, forKey: "productID")
        gearEntity.setValue("Gear", forKey: "name")
        gearEntity.setValue("gear.png", forKey: "image")
        gearEntity.setValue("http://www.samsung.com/us/mobile/wearable-tech/SM-R7200ZWAXAR", forKey: "url")
        gearEntity.setValue(2, forKey: "position")
        
        //Warby Parker Products
        let henryEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        henryEntity.setValue(2, forKey: "companyID")
        henryEntity.setValue(7, forKey: "productID")
        henryEntity.setValue("Henry", forKey: "name")
        henryEntity.setValue("henry.png", forKey: "image")
        henryEntity.setValue("https://www.warbyparker.com/eyeglasses/men/henry/port-blue", forKey: "url")
        henryEntity.setValue(0, forKey: "position")
        
        let craneEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        craneEntity.setValue(2, forKey: "companyID")
        craneEntity.setValue(8, forKey: "productID")
        craneEntity.setValue("Crane", forKey: "name")
        craneEntity.setValue("crane.png", forKey: "image")
        craneEntity.setValue("https://www.warbyparker.com/eyeglasses/men/crane/atlantic-blue", forKey: "url")
        craneEntity.setValue(1, forKey: "position")
        
        let eatonEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        eatonEntity.setValue(2, forKey: "companyID")
        eatonEntity.setValue(9, forKey: "productID")
        eatonEntity.setValue("Eaton", forKey: "name")
        eatonEntity.setValue("eaton.png", forKey: "image")
        eatonEntity.setValue("https://www.warbyparker.com/eyeglasses/men/eaton/tree-swallow-fade", forKey: "url")
        eatonEntity.setValue(2, forKey: "position")
        
        //Sticker Mule Products
        let diecutEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        diecutEntity.setValue(3, forKey: "companyID")
        diecutEntity.setValue(10, forKey: "productID")
        diecutEntity.setValue("Die Cut", forKey: "name")
        diecutEntity.setValue("diecut.png", forKey: "image")
        diecutEntity.setValue("https://www.stickermule.com/products/die-cut-stickers", forKey: "url")
        diecutEntity.setValue(0, forKey: "position")
        
        let rectangleEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        rectangleEntity.setValue(3, forKey: "companyID")
        rectangleEntity.setValue(11, forKey: "productID")
        rectangleEntity.setValue("Rectangle", forKey: "name")
        rectangleEntity.setValue("rectangle.png", forKey: "image")
        rectangleEntity.setValue("https://www.stickermule.com/products/rectangle-stickers", forKey: "url")
        rectangleEntity.setValue(1, forKey: "position")
        
        let circleEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        circleEntity.setValue(3, forKey: "companyID")
        circleEntity.setValue(12, forKey: "productID")
        circleEntity.setValue("Circle", forKey: "name")
        circleEntity.setValue("circle.png", forKey: "image")
        circleEntity.setValue("https://www.stickermule.com/products/circle-stickers", forKey: "url")
        circleEntity.setValue(2, forKey: "position")
        
        let productResults = [ipadEntity, iphoneEntity,macbookairEntity,applewatchEntity, galaxyEntity, galaxyNoteEntity, gearEntity,henryEntity,craneEntity,eatonEntity,diecutEntity,rectangleEntity,circleEntity]
        
        for result in productResults  {
            products += [Product(inName: result.valueForKey("name") as! String, inURL: result.valueForKey("url") as! String, inImage: result.valueForKey("image") as! String, inCompanyID: result.valueForKey("companyID") as! Int, inProductID: result.valueForKey("productID") as! Int, inPosition: result.valueForKey("position") as! Int)]
        }
        
        addProductsToCompanies()
        
        do {
            try managedContext.save()
        }
        catch {
            print("There is error saving")
        }
        
        managedContext.undoManager = NSUndoManager()
        
    }

}
