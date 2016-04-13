//
//  AddCompany.swift
//  navcontrol
//
//  Created by Adam Kornfield on 4/12/16.
//  Copyright © 2016 Baron Fig, LLC. All rights reserved.
//

import UIKit

class AddEditCompany : UIViewController, UITextFieldDelegate {
    
    var company : Company = Company()
    var editExisting = 0
    
    @IBOutlet var coNameTextField: UITextField!
    @IBOutlet var logoTextfield: UITextField!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        coNameTextField.delegate = self
        logoTextfield.delegate = self
        
        
        if editExisting == 0 {
            self.title = "Add Company"
            saveButton.enabled = false
        }
        else {
            self.title = "Edit Company"
            saveButton.enabled = true
            coNameTextField.text = company.name
            logoTextfield.text = company.image
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (coNameTextField.text! != "" && logoTextfield.text! != "") {
            saveButton.enabled = true
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (coNameTextField.text! != "" && logoTextfield.text! != "") {
            saveButton.enabled = true
        }
        return true
    }

    
    @IBAction func removeKeyboards(sender: AnyObject) {
        coNameTextField.resignFirstResponder()
        logoTextfield.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as! UIBarButtonItem == saveButton {
            
            if editExisting == 0 {
                company = Company(inName: coNameTextField.text!, inProducts: [], inImage: logoTextfield.text!)
            }
            else {
                company.name = coNameTextField.text!
                company.image = logoTextfield.text!
            }
            
        }
    }
    

}
