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
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [textFieldFirstName, textFieldLastName, textFieldEmail, textFieldPassword, textFieldPasswordConfirm]
        for textField in textFields {
            textField.delegate = self
            textField.tintColor = UIColor.gray
        }
        ViewHelper.setupCornerRadius(for: [buttonCancel, buttonSignUp])
        showLoading(show: false)
        textFieldFirstName.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
    
    @IBAction func OnSignUpAttempt(sender: UIButton) {
        var errorMessage = ""
        var errorView:UITextField = UITextField()
        hideError()
        showLoading(show: false)
        
        if
            let firstName = textFieldFirstName.text,
            let lastName = textFieldLastName.text,
            let email = textFieldEmail.text,
            let password = textFieldPassword.text,
            let passwordConfirm = textFieldPasswordConfirm.text {
            
            if !isNameValid(name: firstName) {
                errorMessage = "Please enter a correct first name"
                errorView = textFieldFirstName
            } else if !isNameValid(name: lastName) {
                errorMessage = "Please enter a correct last name"
                errorView = textFieldLastName
            } else if !isEmailValid(email: email) {
                errorMessage = "Please enter a correct email"
                errorView = textFieldEmail
            } else if !isPasswordValid(password: password) {
                errorMessage = "The password you provided is too short"
                errorView = textFieldPassword
            } else if !isPasswordConfirmed(password: password, passwordConfirm: passwordConfirm) {
                errorMessage = "The passwords you provided are not identical"
                errorView = textFieldPassword
            }
            
            if (errorMessage.isEmpty) {
                print("Everything went fine")
                showLoading(show: true)
                AuthServer.signUp(firstName: firstName, lastName: lastName, email: email, password: password, completion: { (error) in
                    self.showLoading(show: false)
                    if error {
                        self.showError(error: "Could not connect to the server")
                    } else {
                        self.showSuccess(completion: {
                            startSignIn(currentViewController: self, modalTransitionStyle: .coverVertical)
                        })
                    }

                })
            } else {
                showError(error: errorMessage)
                errorView.becomeFirstResponder()
                errorView.selectedTextRange = errorView.textRange(from:errorView.beginningOfDocument, to: errorView.endOfDocument)
            }

        }
    }
    
    func isNameValid(name:String) -> Bool {
        return name.characters.count > 1
    }
    
    func isEmailValid(email:String) -> Bool {
        return email.range(of:"@") != nil && email.range(of: ".") != nil
    }
    
    func isPasswordValid(password:String) -> Bool {
        return password.characters.count >= 6
    }
    
    func isPasswordConfirmed(password:String, passwordConfirm:String) -> Bool {
        return password == passwordConfirm
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
    
    func showSuccess(completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Success", message:
            "An e-mail has been sent to you. Please open it and click on the confirmation link to proceed.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: completion)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextIndex = textFields.index(of: textField)! + 1;
        if nextIndex < textFields.count {
            textFields[nextIndex].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            OnSignUpAttempt(sender: UIButton())
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAllResponders()
    }
    
    func resignAllResponders() {
        for textField in textFields {
            if textField.isFirstResponder {
                textField.resignFirstResponder()
            }
        }
    }
}
