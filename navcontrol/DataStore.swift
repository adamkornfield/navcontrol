//
//  DataStore.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class DataStore : NSObject  {
    
    static let sharedInstance = DataStore()
    var companies : [Company] = []
    var products : [Product] = []
    var fileURL : String = ""
    var productHighestID = 0
    var companyHighestID = 0
    
    private override init() {
        super.init()
        openDB()
        openDBCompanies()
        openDBProducts()
        sortProducts()
        sortCompanies()
        addProductsToCompanies()
    }
    
    func openDB() {
        let fileManager = NSFileManager.defaultManager()
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        fileURL = directory[0] + "/navcontrol.db"
        let pathToBundledDB = NSBundle.mainBundle().pathForResource("navcontrol", ofType: "db")
        
        if (fileManager.fileExistsAtPath(fileURL)) {
        }
        else {
            try! fileManager.copyItemAtPath(pathToBundledDB!, toPath: fileURL)
        }
    }
    
    func openDBCompanies() {
        var db: COpaquePointer = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let querySQL = "SELECT * FROM Company"
            var statement: COpaquePointer = nil

            if sqlite3_prepare(db, querySQL, -1, &statement, nil) == SQLITE_OK {
                while sqlite3_step(statement) == SQLITE_ROW {
                    let id = sqlite3_column_int64(statement, 0)
                    //print("id = \(id); ", terminator: "")
            
                    var nameString = ""
                    var imageString = ""
                    var stockString = ""

                    let name = sqlite3_column_text(statement, 1)
                    if name != nil {
                        nameString = String.fromCString(UnsafePointer<Int8>(name))!
                        //print("name = \(nameString)")
                    } else {
                        print("name not found")
                    }
                    
                    let image = sqlite3_column_text(statement, 2)
                    if image != nil {
                        imageString = String.fromCString(UnsafePointer<Int8>(image))!
                        //print("image = \(imageString)")
                    } else {
                        print("image not found")
                    }
                    
                    let stock = sqlite3_column_text(statement, 3)
                    if stock != nil {
                        stockString = String.fromCString(UnsafePointer<Int8>(stock))!
                        //print("stock = \(stockString)")
                    } else {
                        print("stock not found")
                    }

                    let position = sqlite3_column_int64(statement, 5)
                    
                    if Int(id) > companyHighestID {
                        companyHighestID = Int(id)
                    }
                    let newCompany = Company(inName: nameString, inProducts: [], inImage: imageString, inStock: stockString, inID: Int(id), inPosition: Int(position) )
                    companies += [newCompany]
                }
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing select: \(errmsg!)")
            }
        }
        else {
            print("error opening database")
        }
    }
    
    func openDBProducts() {

        var db: COpaquePointer = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let querySQL = "SELECT * FROM Product"
            var statement: COpaquePointer = nil
            
            
            if sqlite3_prepare(db, querySQL, -1, &statement, nil) == SQLITE_OK {
                
                while sqlite3_step(statement) == SQLITE_ROW {
                    let productID = sqlite3_column_int64(statement, 0)
                    let companyID = sqlite3_column_int64(statement, 1)
                    //print("id = \(id); ", terminator: "")
                    
                    var nameString = ""
                    var imageString = ""
                    var urlString = ""
                    

                    let name = sqlite3_column_text(statement, 2)
                    if name != nil {
                        nameString = String.fromCString(UnsafePointer<Int8>(name))!
                        //print("name = \(nameString)")
                    } else {
                        print("name not found")
                    }
                    
                    let image = sqlite3_column_text(statement, 3)
                    if image != nil {
                        imageString = String.fromCString(UnsafePointer<Int8>(image))!
                        //print("image = \(imageString)")
                    } else {
                        print("image not found")
                    }
                    
                    let url = sqlite3_column_text(statement, 4)
                    if url != nil {
                        urlString = String.fromCString(UnsafePointer<Int8>(url))!
                        //print("stock = \(stockString)")
                    } else {
                        print("stock not found")
                    }
                    
                    let position = sqlite3_column_int64(statement, 5)
                    
                    let newProduct = Product(inName: nameString, inURL: urlString, inImage: imageString, inCompanyID: Int(companyID), inProductID: Int(productID), inPosition: Int(position))
                    
                    if Int(productID) > productHighestID {
                        productHighestID = Int(productID)
                    }
                    products += [newProduct]
                }
                
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing select: \(errmsg!)")
            }
        }
        else {
            print("error opening database")
        }
    }
    
    
    
    func addProduct(newProduct : Product, companySelected : Company) {
        
        companySelected.products += [newProduct]
        
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        productHighestID += 1
        newProduct.productID = productHighestID
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let insertSQL = "INSERT INTO Product VALUES(\(newProduct.productID),\(newProduct.companyID),\"\(newProduct.name)\",\"\(newProduct.image)\",\"\(newProduct.url)\",\(newProduct.position));"
            
            //print(insertSQL)
            
            if sqlite3_exec(db, insertSQL, nil, nil, &error) == SQLITE_OK {

                //print("Added to Products table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing select: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
    }
    
    func updateProduct(updateProduct : Product) {
        
        
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let updateSQL = "UPDATE Product SET company_id=\(updateProduct.companyID), name=\"\(updateProduct.name)\", image=\"\(updateProduct.image)\", url=\"\(updateProduct.url)\", position=\(updateProduct.position) WHERE product_id=\(updateProduct.productID);"
            
            //print(updateSQL)
            
            if sqlite3_exec(db, updateSQL, nil, nil, &error) == SQLITE_OK {
                
                //print("Updated product in table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing update: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
    }

    
    
    func deleteProduct(companySelected : Company, index : Int) {
        
        let deleteProduct = companySelected.products[index]
        
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let deleteSQL = "DELETE FROM Product WHERE product_id=\(deleteProduct.productID);"
            //print(deleteSQL)
            if sqlite3_exec(db, deleteSQL, nil, nil, &error) == SQLITE_OK {
                //print("Deleted product from table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing delete: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
        
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
    }
    
    
    func sortProducts() {
        products.sortInPlace({ $0.position < $1.position })
    }
    
    
    func sortCompanies() {
        companies.sortInPlace({ $0.position < $1.position })
    }
    
    
    
    func addCompany(newCompany : Company) {
        companies += [newCompany]
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        companyHighestID += 1
        newCompany.id = companyHighestID
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let insertSQL = "INSERT INTO Company VALUES(\(newCompany.id),\"\(newCompany.name)\",\"\(newCompany.image)\",\"\(newCompany.stock)\",\"\(newCompany.stockPrice)\",\(newCompany.position));"
            //print(insertSQL)
            if sqlite3_exec(db, insertSQL, nil, nil, &error) == SQLITE_OK {
                //print("Added to Company table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing select: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
    }
    
    func updateCompany(updateCompany : Company) {
        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let updateSQL = "UPDATE Company SET name=\"\(updateCompany.name)\", image=\"\(updateCompany.image)\", stock=\"\(updateCompany.stock)\", position=\(updateCompany.position) WHERE company_id=\(updateCompany.id);"
            //print(updateSQL)
            if sqlite3_exec(db, updateSQL, nil, nil, &error) == SQLITE_OK {
                //print("Updated company in table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing update: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
    }
    func deleteCompany(deleteCompany : Company, index : Int) {
        
        

        var db: COpaquePointer = nil
        var error: UnsafeMutablePointer<Int8> = nil
        if sqlite3_open(fileURL, &db) == SQLITE_OK {
            let deleteSQL = "DELETE FROM Company WHERE company_id=\(deleteCompany.id);"
            //print(deleteSQL)
            if sqlite3_exec(db, deleteSQL, nil, nil, &error) == SQLITE_OK {
                //print("Deleted company from table")
            }
            else {
                let errmsg = String.fromCString(sqlite3_errmsg(db))
                print("error preparing delete: \(errmsg!)")
            }
            sqlite3_close(db)
        }
        else {
            print("error opening database")
        }
        
        companies.removeAtIndex(index)
    }
    
    func getCompanies() -> [Company] {
        return companies
    }


}
