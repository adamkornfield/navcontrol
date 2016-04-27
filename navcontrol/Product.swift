//
//  Products.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/11/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit


class Product : NSObject {
    
    var companyID = 0
    var productID = 0
    var name = ""
    var url = ""
    var image = ""
    var position : Int = 0
    
    init(inName : String, inURL : String, inImage : String, inCompanyID : Int, inProductID : Int, inPosition : Int) {
        companyID = inCompanyID
        name = inName
        url = inURL
        image = inImage
        productID = inProductID
        position = inPosition
        
    }
    
    convenience override init() {
        self.init(inName: "", inURL: "", inImage: "", inCompanyID: 0, inProductID: 0, inPosition: 0)
    }
    

}