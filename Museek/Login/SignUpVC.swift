//
//  RegisterVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/3/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController{

    @IBOutlet weak var emailTextField: UITextField!
    
    private var nameIsOk = false
    private var ussernameIsOk = false
    private var emailIsOk = false
    private var passwordIsOk = false
    
    
//    @IBAction private func passwordsMatch(_ sender: UITextField) {
//        if sender.text == passwordTextField.text {
////            display check mark
//        } else {
////           say passwords dont match
//        }
//
//    }
    
    
    //checks wether enter email is in correct email format
    private func isValid(emailString email: String)-> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //regEx
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: email)
    }
}
