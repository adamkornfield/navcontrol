//
//  Products.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/11/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class Product : NSObject {
    
    var name = ""
    var url = ""
    var image = ""
    
    init(inName : String, inURL : String, inImage : String) {
        
        name = inName
        url = inURL
        image = inImage
        
    }
}