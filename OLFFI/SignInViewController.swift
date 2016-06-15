//
//  SignInViewController.swift
//  OLFFI
//
//  Created by Gabriel Morin on 14/06/2016.
//  Copyright © 2016 Gabriel Morin. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textViewError: UITextView!
    @IBOutlet weak var viewFields: UIView!
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        showLoading(false)
        textFieldEmail.becomeFirstResponder()
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
    
    @IBAction func onSignInAttempt(sender: UIButton) {
        var errorMessage = ""
        var errorView:UITextField = UITextField()
        hideError()
        showLoading(false)
        
        if let
            email = textFieldEmail.text,
            password = textFieldPassword.text {
            
            if !isEmailValid(email) {
                errorMessage = "Please enter a correct email"
                errorView = textFieldEmail
            } else if !isPasswordValid(password) {
                errorMessage = "The password you provided is too short"
                errorView = textFieldPassword
            }
            
            if (errorMessage.isEmpty) {
                showLoading(true)
                BasicAuth.logIn(email, password: password, completion: { (error) in
                    self.showLoading(false)
                    if error {
                        self.showError("Could not connect to the server")
                    } else {
                        startWebApp(self)
                    }
                })
            } else {
                showError(errorMessage)
                errorView.becomeFirstResponder()
                errorView.selectedTextRange = errorView.textRangeFromPosition(errorView.beginningOfDocument, toPosition: errorView.endOfDocument)
            }
            
        }
    }
    
    func isEmailValid(email:String) -> Bool {
        return email.containsString("@") && email.containsString(".")
    }
    
    func isPasswordValid(password:String) -> Bool {
        return password.characters.count > 4
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
     if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textField.resignFirstResponder()
            onSignInAttempt(UIButton())
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignAllResponders()
    }
    
    func resignAllResponders() {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
}
