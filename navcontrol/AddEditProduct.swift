//
//  AddEditProduct.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class AddEditProduct : UIViewController, UITextFieldDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    

    @IBOutlet var productNameTextField: UITextField!
    @IBOutlet var imageNameTextField: UITextField!
    @IBOutlet var webpageURLTextField: UITextField!
    
    var newProduct : Product = Product()
    
    override func viewDidLoad() {
        
        saveButton.enabled = false
        self.title = "Add Product"
        productNameTextField.delegate = self
        imageNameTextField.delegate = self
        webpageURLTextField.delegate = self
    }
    

    
    func textFieldDidEndEditing(textField: UITextField) {
        if (productNameTextField.text! != "" && imageNameTextField.text! != "" && webpageURLTextField.text! != "") {
            saveButton.enabled = true
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == saveButton {
            newProduct = Product(inName: productNameTextField.text!, inURL: webpageURLTextField.text! , inImage: imageNameTextField.text!)
        }
    }
    
    @IBAction func pressedBackground(sender: AnyObject) {
        productNameTextField.resignFirstResponder()
        imageNameTextField.resignFirstResponder()
        webpageURLTextField.resignFirstResponder()
    }
    
}
