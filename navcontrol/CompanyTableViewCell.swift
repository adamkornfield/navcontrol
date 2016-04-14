//
//  CompanyTableViewCell.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/13/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var stockSymbolLabel: UILabel!
    @IBOutlet var stockPriceLabel: UILabel!
    @IBOutlet var leadingImageViewConstraint: NSLayoutConstraint!
    

    
//    override func layoutSubviews() {
//
//        let indentPoints : CGFloat = 0.0
//        super.layoutSubviews()
////        self.contentView.frame = CGRectMake(indentPoints, self.contentView.frame.origin.y, self.contentView.frame.size.width - indentPoints, self.contentView.frame.size.height)
//        self.contentView.frame = CGRect(x: 100.0, y: self.contentView.frame.origin.y, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
//
//    }
    

}
