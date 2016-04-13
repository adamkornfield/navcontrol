//
//  DataStore.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class DataStore : NSObject  {
    
    static let sharedInstance = DataStore()
    
    
    let iPad  = Product(inName: "iPad", inURL: "http://www.apple.com/ipad/", inImage: "ipad.png")
    let iPhone = Product(inName: "iPhone", inURL: "http://www.apple.com/iphone/", inImage: "iphone.png")
    let macBookAir = Product(inName: "MacBook Air", inURL: "http://www.apple.com/macbook-air/", inImage: "macbookair.png")
    let appleWatch = Product(inName: "Apple Watch", inURL: "http://www.apple.com/watch/", inImage: "applewatch.png")
    
    let galaxy = Product(inName: "Galaxy", inURL: "https://www.samsung.com/us/mobile/cell-phones/SM-G935AZDAATT", inImage: "galaxy.png")
    let galaxyNote = Product(inName: "Galaxy Note", inURL: "http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT", inImage: "galaxynote.png")
    let gear = Product(inName: "Gear", inURL: "http://www.samsung.com/us/mobile/wearable-tech/SM-R7200ZWAXAR", inImage: "gear.png")
    
    let henry = Product(inName: "Henry", inURL: "https://www.warbyparker.com/eyeglasses/men/henry/port-blue", inImage: "henry.png")
    let crane = Product(inName: "Crane", inURL: "https://www.warbyparker.com/eyeglasses/men/crane/atlantic-blue", inImage: "crane.png")
    let eaton = Product(inName: "Eaton", inURL: "https://www.warbyparker.com/eyeglasses/men/eaton/tree-swallow-fade", inImage: "eaton.png")
    
    let dieCut = Product(inName: "Die Cut", inURL: "https://www.stickermule.com/products/die-cut-stickers", inImage: "diecut.png")
    let rectangle = Product(inName: "Rectangle", inURL: "https://www.stickermule.com/products/rectangle-stickers", inImage: "rectangle")
    let circle = Product(inName: "Circle", inURL: "https://www.stickermule.com/products/circle-stickers", inImage: "circle.png")
    
    var apple : Company = Company()
    var samsung : Company = Company()
    var warbyParker : Company = Company()
    var stickerMule : Company = Company()
    
    private override init() {
        apple = Company(inName: "Apple", inProducts: [iPad,iPhone,macBookAir,appleWatch], inImage: "apple.png", inStock: "AAPL")
        samsung = Company(inName: "Samsung", inProducts: [galaxy, galaxyNote, gear], inImage: "samsung.png", inStock: "005930.KS")
        warbyParker = Company(inName: "Warby Parker", inProducts: [henry,crane,eaton], inImage: "warbyparker.png", inStock: "")
        stickerMule = Company(inName: "Sticker Mule", inProducts: [dieCut, rectangle, circle], inImage: "stickermule.png", inStock: "")
    }
    
    func getCompanies() -> [Company] {
        return [apple,samsung,warbyParker,stickerMule]
    }
    

}
