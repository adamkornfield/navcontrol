//
//  getStockPrice.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/13/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

func getStockPrice(companies : [Company], companyTableView : UITableView) {
    
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
    
    
    allCompanyStocks.removeAtIndex(allCompanyStocks.endIndex.predecessor())
    //print(allCompanyStocks)
    //print(positionsWithStocks)
    
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
                //print(priceArray)
                
                
                
                
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
