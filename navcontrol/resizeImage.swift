//
//  resizeImage.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/13/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

func resizeImage(image:UIImage, newWidth: CGFloat) -> UIImage {
    
    let newScale = newWidth/image.size.width
    let newHeight = newScale * image.size.height
    UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
    image.drawInRect(CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
    let theNewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return theNewImage
}