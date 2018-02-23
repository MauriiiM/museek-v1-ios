//
//  LoginVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

class LoginVC: UIViewController{
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction fileprivate func signIn(_ sender: UIButton) {
        let userEmail = userEmailTextField.text
        let password = passwordTextField.text
        AuthService.signIn(withEmail: userEmail!, password: password!){ error in
            if error == nil {//success login
                self.performSegue(withIdentifier: "toMainSb", sender: self)
            } else {//user info didn't match an account
                let errorMsg = "Please check your email and password, then try again."
                let alert = UIAlertController(title: "Error Occurred", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
