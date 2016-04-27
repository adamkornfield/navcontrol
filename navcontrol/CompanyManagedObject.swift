//
//  CompanyManagedObject.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/25/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import CoreData

class CompanyManagedObject: NSManagedObject {
    
    @NSManaged var name : String?
    @NSManaged var products : [Product]?
    @NSManaged var image : String?
    @NSManaged var stock : String?
    @NSManaged var stockPrice : String?
    @NSManaged var id : Int
    @NSManaged var position : Int

}
