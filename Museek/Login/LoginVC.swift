//
//  LoginVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController{
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        let userEmail = userEmailTextField.text
        let password = passwordTextField.text
        Auth.auth().signIn(withEmail: userEmail!,
                           password: password!,
                           completion: { (user, error) in
                            if let u = user {
                                print("user LOGGED IN")
                            } else {
                                //
                            }
        })
    }
    
    @IBAction private func unwind(segue: UIStoryboardSegue){
        print("came from login")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}
