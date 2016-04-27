//
//  DataStore.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import CoreData

class DataStore : NSObject  {
    
    static let sharedInstance = DataStore()
    var companies : [Company] = []
    var products : [Product] = []
    var fileURL : String = ""
    var productHighestID = 0
    var companyHighestID = 0
    
    var managedContext = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
    
    private override init() {
        super.init()
        
        
        if checkDoesCoreDataExists() == false
        {
            loadHardCodedValues()
            addProductsToCompanies()
        }
        else {
            reloadCompaniesAndProducts()
        }
        
        
    }
    
    
    
    func reloadCompaniesAndProducts() {
        loadExistingCompanies()
        loadExistingProducts()
        addProductsToCompanies()
        
    }
    
    func undoCompaniesAndProducts() {
        managedContext.undo()
        companies.removeAll()
        reloadCompaniesAndProducts()
    }
    
    func undoProducts() {
        managedContext.undo()
        
        for company in companies {
            company.products.removeAll()
        }
        loadExistingProducts()
        addProductsToCompanies()

    }
    
    func checkDoesCoreDataExists() -> Bool {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
        managedContext.undoManager = NSUndoManager()
        
        
        let fetchRequest = NSFetchRequest(entityName: "Company")
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error fetching")
        }

        if results.count > 0 {
            return true
        }
        else {
            return false
        }

    }
    
    func loadExistingCompanies() {
        
        let fetchRequest = NSFetchRequest(entityName: "Company")
        let sortDescriptors = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error fetching")
        }
        
        for result in results  {
            //print(result.valueForKey("name")!)
            companies += [Company(inName: result.valueForKey("name") as! String, inProducts: [], inImage: result.valueForKey("image") as! String, inStock: result.valueForKey("stock") as! String, inID: result.valueForKey("id") as! Int, inPosition: result.valueForKey("position") as! Int)]
            
            if result.valueForKey("id") as! Int > companyHighestID {
                companyHighestID = result.valueForKey("id") as! Int
            }

            
        }
    }
    
    func loadExistingProducts() {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        let sortDescriptors = NSSortDescriptor(key: "position", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error fetching")
        }
        
        for result in results  {
            //print(result.valueForKey("name")!)
            products += [Product(inName: result.valueForKey("name") as! String, inURL: result.valueForKey("url") as! String, inImage: result.valueForKey("image") as! String, inCompanyID: result.valueForKey("companyID") as! Int, inProductID: result.valueForKey("productID") as! Int, inPosition: result.valueForKey("position") as! Int)]
            
            if result.valueForKey("productID") as! Int > productHighestID {
                productHighestID = result.valueForKey("productID") as! Int
            }
        }

        
        
        
    }
    
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
        
        do {
            try managedContext.save()
        }
        catch {
            print("There is error saving")
        }
        
        
    }
    
    

    
    
    
    func addProduct(newProduct : Product, companySelected : Company) {
        productHighestID += 1
        newProduct.productID = productHighestID
        companySelected.products += [newProduct]
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: managedContext)
        newEntity.setValue(newProduct.companyID, forKey: "companyID")
        newEntity.setValue(newProduct.productID, forKey: "productID")
        newEntity.setValue(newProduct.name, forKey: "name")
        newEntity.setValue(newProduct.image, forKey: "image")
        newEntity.setValue(newProduct.url, forKey: "url")
        newEntity.setValue(newProduct.position, forKey: "position")
        
        do {
            try managedContext.save()
        }
        catch {
            print("Error saving")
        }
        
    }
    
    
    
    
    func updateProduct(updateProduct : Product) {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        let predicate = NSPredicate(format: "productID == %lu", updateProduct.productID)
        fetchRequest.predicate = predicate
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error executing fetch request")
        }
        
        results[0].setValue(updateProduct.companyID, forKey: "companyID")
        results[0].setValue(updateProduct.productID, forKey: "productID")
        results[0].setValue(updateProduct.name, forKey: "name")
        results[0].setValue(updateProduct.image, forKey: "image")
        results[0].setValue(updateProduct.url, forKey: "url")
        results[0].setValue(updateProduct.position, forKey: "position")
        
        do {
            try managedContext.save()
        }
        catch {
            print("Couldn't update product")
        }
        
        
        
    }

    
    
    func deleteProduct(companySelected : Company, index : Int) {
        
        let deleteProduct = companySelected.products[index]
        
        let fetchRequest = NSFetchRequest(entityName: "Product")
        let predicate = NSPredicate(format: "productID == %lu", deleteProduct.productID)
        fetchRequest.predicate = predicate
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Couldn't execute delete product fetch")
        }
        

        managedContext.deleteObject(results[0] as! NSManagedObject)

        
        companySelected.products.removeAtIndex(index)
    }

    
    func addProductsToCompanies() {
        for count in 0 ..< products.count {
            let companyToAdd = products[count].companyID
            for count2 in 0 ..< companies.count {
                if (companies[count2].id == companyToAdd) {
                    companies[count2].products += [products[count]]
                }
            }
        }
        products.removeAll()
    }
    
    
    func sortProducts() {
        products.sortInPlace({ $0.position < $1.position })
    }
    
    
    func sortCompanies() {
        companies.sortInPlace({ $0.position < $1.position })
    }
    
    
    
    func addCompany(newCompany : Company) {
        
        companyHighestID += 1
        newCompany.id = companyHighestID
        companies += [newCompany]
        
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: managedContext)
        newEntity.setValue(newCompany.id, forKey: "id")
        newEntity.setValue(newCompany.image, forKey: "image")
        newEntity.setValue(newCompany.name, forKey: "name")
        newEntity.setValue(newCompany.position, forKey: "position")
        newEntity.setValue(newCompany.stock, forKey: "stock")
        
        do {
            try managedContext.save()
        }
        catch {
            print("Couldn't save new Company")
        }
    }
    
    func updateCompany(updateCompany : Company) {
        let fetchRequest = NSFetchRequest(entityName: "Company")
        let predicate = NSPredicate(format: "id == %lu", updateCompany.id)
        fetchRequest.predicate = predicate
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Couldn't load Company for update")
        }
        
        results[0].setValue(updateCompany.id, forKey: "id")
        results[0].setValue(updateCompany.image, forKey: "image")
        results[0].setValue(updateCompany.name, forKey: "name")
        results[0].setValue(updateCompany.position, forKey: "position")
        results[0].setValue(updateCompany.stock, forKey: "stock")
        
        do {
            try managedContext.save()
        }
        catch {
            print("Couldn't save updated Company")
        }
        
    }
    
    func deleteCompany(index : Int) {
        
        let deleteCompany = companies[index]
        
        let fetchRequest = NSFetchRequest(entityName: "Company")
        let predicate = NSPredicate(format: "id == %lu", deleteCompany.id)
        fetchRequest.predicate = predicate
        
        var results : [AnyObject] = []
        do {
            results = try managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Couldn't fetch company to delete")
        }
        
        managedContext.deleteObject(results[0] as! NSManagedObject)
        companies.removeAtIndex(index)
        
    }
    



}
