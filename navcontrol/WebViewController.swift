//
//  WebViewController.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/7/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class WebViewController : UIViewController {
    
    @IBOutlet var webViewer: UIWebView!
    
    var urlString = ""
    
    override func viewDidLoad() {
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        webViewer.loadRequest(request)
        
        
        
    }
    
    
    
}
