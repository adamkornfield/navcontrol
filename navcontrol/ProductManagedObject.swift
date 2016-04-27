//
//  ProductManagedObject.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/25/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import CoreData

class ProductManagedObject: NSManagedObject {

    @NSManaged var companyID : Int
    @NSManaged var productID : Int
    @NSManaged var name : String?
    @NSManaged var url : String?
    @NSManaged var image : String?
    @NSManaged var position : Int
    
    
}
