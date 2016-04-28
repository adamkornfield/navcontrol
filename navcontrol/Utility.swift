//
//  Utility.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/28/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class Utility : NSObject {
    
    class func resizeImage(image:UIImage, newWidth: CGFloat) -> UIImage {
        
        let newScale = newWidth/image.size.width
        let newHeight = newScale * image.size.height
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: newWidth, height: newHeight))
        let theNewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return theNewImage
    }
    
    
    class func getStockPrice(companies : [Company], companyTableView : UITableView) {
        
        var allCompanyStocks = ""
        var count = 0
        var positionsWithStocks : [Int] = []
        var priceArray : [String] = []
        
        for company in companies {
            if company.stock != "" {
                allCompanyStocks += (company.stock + "+")
                positionsWithStocks.append(count)
            }
            count += 1
        }
        
        if allCompanyStocks.characters.count > 0 {
            allCompanyStocks.removeAtIndex(allCompanyStocks.endIndex.predecessor())
            let url = "http://finance.yahoo.com/d/quotes.csv?s=" + allCompanyStocks + "&f=l1"
            let session = NSURLSession.sharedSession()
            
            let urlPath = NSURL(string: url)
            let request = NSMutableURLRequest(URL: urlPath!)
            request.addValue("text/csv", forHTTPHeaderField: "Content-Type")
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request) {
                (let data, let response, let error) in
                if error == nil {
                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    priceArray  = (datastring?.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()))!
                    priceArray.removeLast()
                    
                    func updatePrices() {
                        for count in 0 ..< priceArray.count {
                            if companies[positionsWithStocks[count]].stock == "005930.KS" {
                                companies[positionsWithStocks[count]].stockPrice = String(format: "%.2f", Double(priceArray[count])!/1145.60)
                            }
                            else {
                                companies[positionsWithStocks[count]].stockPrice = String(format: "%.2f", Double(priceArray[count])!)
                            }
                        }
                        companyTableView.reloadData()
                    }
                    dispatch_async(dispatch_get_main_queue(), updatePrices)
                }
                else {
                }
            }
            task.resume()
            
        }
    }
    
    
}
