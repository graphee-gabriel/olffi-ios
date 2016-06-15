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
    
    @IBAction func onSignInAttempt(sender: UIButton) {
        var errorMessage = ""
        var errorView:UITextField = UITextField()
        textViewError.hidden = true
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
                print("Everything went fine")
                showLoading(true)
                startWebApp(self)
            } else {
                textViewError.hidden = false
                textViewError.text = errorMessage
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
}
