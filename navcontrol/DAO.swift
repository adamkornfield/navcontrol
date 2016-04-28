//
//  DAO
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import CoreData

class DAO : NSObject  {
    
    static let sharedInstance = DAO()
    var companies : [Company] = []
    var products : [Product] = []
    var fileURL : String = ""
    var productHighestID = 0
    var companyHighestID = 0
    var undoButtonVar : UIBarButtonItem!
    
    var managedContext = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
    
    private override init() {
        super.init()
        
        if checkDoesCoreDataExists() == false
        {
            loadHardCodedValues()
            
        }
        else {
            reloadCompaniesAndProducts()
        }
    }
    
    func canUndo() -> Bool {
        return (managedContext.undoManager?.canUndo)!
    }
    
    func clearUndos() {
        managedContext.undoManager?.removeAllActions()
    }
    
    func undoCompaniesAndProducts() {
        managedContext.undo()
        companies.removeAll()
        reloadCompaniesAndProducts()
    }
    
    func reloadCompaniesAndProducts() {
        loadExistingCompanies()
        loadExistingProducts()
        addProductsToCompanies()
        do {
            try managedContext.save()
        }
        catch {
            print("There is error saving")
        }
        
    }
    
    func undoProducts() {
        managedContext.undo()
        reloadProducts()
        addProductsToCompanies()
    }
    
    func reloadProducts() {
        for company in companies {
            company.products.removeAll()
        }
        loadExistingProducts()
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
            try results = managedContext.executeFetchRequest(fetchRequest)
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
            try results = managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error fetching")
        }
        
        for result in results  {
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
            try results = managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Error fetching")
        }
        
        for result in results  {
            products += [Product(inName: result.valueForKey("name") as! String, inURL: result.valueForKey("url") as! String, inImage: result.valueForKey("image") as! String, inCompanyID: result.valueForKey("companyID") as! Int, inProductID: result.valueForKey("productID") as! Int, inPosition: result.valueForKey("position") as! Int)]
            
            if result.valueForKey("productID") as! Int > productHighestID {
                productHighestID = result.valueForKey("productID") as! Int
            }
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
            try results = managedContext.executeFetchRequest(fetchRequest)
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
            try results =  managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Couldn't execute delete product fetch")
        }
        
        managedContext.deleteObject(results[0] as! NSManagedObject)
        companySelected.products.removeAtIndex(index)
        
        do {
            try managedContext.save()
        }
        catch {
            print("Couldn't save updated Company")
        }
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
            try results = managedContext.executeFetchRequest(fetchRequest)
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
            try results =  managedContext.executeFetchRequest(fetchRequest)
        }
        catch {
            print("Couldn't fetch company to delete")
        }
        
        managedContext.deleteObject(results[0] as! NSManagedObject)
        companies.removeAtIndex(index)
        
        do {
            try managedContext.save()
        }
        catch {
            print("Couldn't save updated Company")
        }
        
    }
    
}
