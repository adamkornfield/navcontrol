//
//  Company.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/11/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class Company : NSObject {
    
    var name : String = ""
    var products : [Product] = []
    var image = ""
    
    init(inName : String, inProducts : [Product], inImage : String) {
        name = inName
        products = inProducts
        image = inImage
        
    }
    
    convenience override init() {
        self.init(inName: "", inProducts: [], inImage: "")
    }
}