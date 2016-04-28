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
    
    var newProduct : Product?
    var inEditing = 0
    
    override func viewDidLoad() {
        
        if Bool(inEditing) {
            saveButton.enabled = true
        }
        else {
            saveButton.enabled = false
        }
        
        productNameTextField.delegate = self
        imageNameTextField.delegate = self
        webpageURLTextField.delegate = self
        
        if inEditing == 0 {
            self.title = "Add Product"
        }
        else {
            self.title = "Edit Product"
            productNameTextField.text = newProduct!.name
            imageNameTextField.text = newProduct!.image
            webpageURLTextField.text = newProduct!.url
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (productNameTextField.text! != "" && imageNameTextField.text! != "" && webpageURLTextField.text! != "") {
            saveButton.enabled = true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (productNameTextField.text! != "" && imageNameTextField.text! != "" && webpageURLTextField.text! != "") {
            saveButton.enabled = true
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == saveButton {
            if inEditing == 0 {
                newProduct = Product(inName: productNameTextField.text!, inURL: webpageURLTextField.text! , inImage: imageNameTextField.text!, inCompanyID: 0, inProductID: 0, inPosition: 0)
            }
            else {
                newProduct!.name = productNameTextField.text!
                newProduct!.image = imageNameTextField.text!
                newProduct!.url = webpageURLTextField.text!
            }
        }
    }
    
    @IBAction func pressedBackground(sender: AnyObject) {
        productNameTextField.resignFirstResponder()
        imageNameTextField.resignFirstResponder()
        webpageURLTextField.resignFirstResponder()
    }
    
}
