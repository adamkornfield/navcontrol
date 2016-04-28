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
    var image : String = ""
    var stock : String = ""
    var stockPrice : String = ""
    var id : Int = 0
    var position : Int = 0
    
    init(inName : String, inProducts : [Product], inImage : String, inStock : String, inID : Int, inPosition : Int) {
        name = inName
        products = inProducts
        image = inImage
        stock = inStock
        id = inID
        position = inPosition
        
    }
    
//    convenience override init() {
//        self.init(inName: "", inProducts: [], inImage: "", inStock: "", inID: 0, inPosition: 0)
//    }
}