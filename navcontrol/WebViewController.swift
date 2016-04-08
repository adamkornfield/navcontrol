//
//  WebViewController.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/7/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit
import WebKit

class WebViewController : UIViewController {
    
    @IBOutlet var webViewer: UIWebView!
    
    var urlString = ""
    

    
    override func viewDidLoad() {
        
        self.navigationController!.navigationBar.translucent = false
        self.edgesForExtendedLayout = .None
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        //webViewer.loadRequest(request)
        
        
        let wkWebViewer = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height))
        wkWebViewer.loadRequest(request)
        
        self.view.addSubview(wkWebViewer)
        
        
        
        
    }
    
    
    
}
