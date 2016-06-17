//
//  SignUpViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 13/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPasswordConfirm: UITextField!
    @IBOutlet weak var textViewError: UITextView!
    @IBOutlet weak var viewFields: UIView!
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!
    var textFields:[UITextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [textFieldFirstName, textFieldLastName, textFieldEmail, textFieldPassword, textFieldPasswordConfirm]
        for textField in textFields {
            textField.delegate = self
            textField.tintColor = UIColor.grayColor()
        }
        
        showLoading(false)
        textFieldFirstName.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    @IBAction func onCancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func OnSignUpAttempt(sender: UIButton) {
        var errorMessage = ""
        var errorView:UITextField = UITextField()
        hideError()
        showLoading(false)
        
        if let
            firstName = textFieldFirstName.text,
            lastName = textFieldLastName.text,
            email = textFieldEmail.text,
            password = textFieldPassword.text,
            passwordConfirm = textFieldPasswordConfirm.text {
            
            if !isNameValid(firstName) {
                errorMessage = "Please enter a correct first name"
                errorView = textFieldFirstName
            } else if !isNameValid(lastName) {
                errorMessage = "Please enter a correct last name"
                errorView = textFieldLastName
            } else if !isEmailValid(email) {
                errorMessage = "Please enter a correct email"
                errorView = textFieldEmail
            } else if !isPasswordValid(password) {
                errorMessage = "The password you provided is too short"
                errorView = textFieldPassword
            } else if !isPasswordConfirmed(password, passwordConfirm: passwordConfirm) {
                errorMessage = "The passwords you provided are not identical"
                errorView = textFieldPassword
            }
            
            if (errorMessage.isEmpty) {
                print("Everything went fine")
                showLoading(true)
                BasicAuth.signUp(firstName, lastName: lastName, email: email, password: password, completion: { (error) in
                    self.showLoading(false)
                    if error {
                        self.showError("Could not connect to the server")
                    } else {
                        self.showSuccess({
                            startSignIn(self, modalTransitionStyle: .CoverVertical)
                        })
                    }

                })
            } else {
                showError(errorMessage)
                errorView.becomeFirstResponder()
                errorView.selectedTextRange = errorView.textRangeFromPosition(errorView.beginningOfDocument, toPosition: errorView.endOfDocument)
            }

        }
    }
    
    func isNameValid(name:String) -> Bool {
        return name.characters.count > 1
    }
    
    func isEmailValid(email:String) -> Bool {
        return email.containsString("@") && email.containsString(".")
    }
    
    func isPasswordValid(password:String) -> Bool {
        return password.characters.count >= 6
    }
    
    func isPasswordConfirmed(password:String, passwordConfirm:String) -> Bool {
        return password == passwordConfirm
    }
    
    func showLoading(show:Bool) {
        viewFields.hidden = show
        viewLoading.hidden = !show
        if (show) {
            viewLoading.startAnimating()
        } else {
            viewLoading.stopAnimating()
        }
    }

    func showError(error:String) {
        textViewError.hidden = false
        textViewError.text = error
    }
    
    func hideError() {
        textViewError.hidden = true
        textViewError.text = ""
    }
    
    func showSuccess(completion: () -> Void) {
        let alertController = UIAlertController(title: "Success", message:
            "An e-mail has been sent to you. Please open it and click on the confirmation link to proceed.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: completion)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextIndex = textFields.indexOf(textField)! + 1;
        if nextIndex < textFields.count {
            textFields[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            OnSignUpAttempt(UIButton())
        }
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignAllResponders()
    }
    
    func resignAllResponders() {
        for textField in textFields {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
            }
        }
    }
}
