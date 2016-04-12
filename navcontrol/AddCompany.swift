//
//  AddCompany.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class AddCompany : UIViewController, UITextFieldDelegate {
    
    var newCompany : Company = Company()
    
    @IBOutlet var coNameTextField: UITextField!
    @IBOutlet var logoTextfield: UITextField!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.title = "Add Company"
        coNameTextField.delegate = self
        logoTextfield.delegate = self
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (coNameTextField.text! != "" && logoTextfield.text! != "") {
            saveButton.enabled = true
        }
    }

    
    @IBAction func removeKeyboards(sender: AnyObject) {
        coNameTextField.resignFirstResponder()
        logoTextfield.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == saveButton {
            
            newCompany = Company(inName: coNameTextField.text!, inProducts: [], inImage: logoTextfield.text!)
            
        }
    }
    

}
