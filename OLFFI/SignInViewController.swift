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

    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonLogIn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
        textFieldEmail.tintColor = UIColor.gray
        textFieldPassword.tintColor = UIColor.gray
        
        ViewHelper.setupCornerRadius(for: [buttonCancel, buttonLogIn])
        showLoading(show: false)
        textFieldEmail.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func onCancel(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @IBAction func onSignInAttempt(sender: UIButton) {
        var errorMessage = ""
        var errorView:UITextField = UITextField()
        hideError()
        showLoading(show: false)
        
        if let email = textFieldEmail.text, let password = textFieldPassword.text {
            if !isEmailValid(email: email) {
                errorMessage = "Please enter a correct email"
                errorView = textFieldEmail
            } else if !isPasswordValid(password: password) {
                errorMessage = "The password you provided is too short"
                errorView = textFieldPassword
            }
            
            if (errorMessage.isEmpty) {
                showLoading(show: true)
                AuthServer.logIn(email: email, password: password, completion: { (error) in
                    self.showLoading(show: false)
                    if error {
                        self.showError(error: "Could not connect to the server")
                    } else {
                        AppNavigator(from: self).startMenu()
                    }
                })
            } else {
                showError(error: errorMessage)
                errorView.becomeFirstResponder()
                errorView.selectedTextRange = errorView.textRange(from:errorView.beginningOfDocument, to: errorView.endOfDocument)
            }
            
        }
    }
    
    func isEmailValid(email:String) -> Bool {
        return email.range(of: "@") != nil && email.range(of: ".") != nil
        
    }
    
    func isPasswordValid(password:String) -> Bool {
        return password.characters.count > 4
    }
    
    func showLoading(show:Bool) {
        viewFields.isHidden = show
        viewLoading.isHidden = !show
        if (show) {
            viewLoading.startAnimating()
        } else {
            viewLoading.stopAnimating()
        }
    }

    func showError(error:String) {
        textViewError.isHidden = false
        textViewError.text = error
    }
    
    func hideError() {
        textViewError.isHidden = true
        textViewError.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
     if textField == textFieldEmail {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            textField.resignFirstResponder()
            onSignInAttempt(sender: UIButton())
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAllResponders()
    }
    
    func resignAllResponders() {
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
    }
}
