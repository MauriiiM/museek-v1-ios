//
//  LoginVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVsC: UIViewController{
    @IBOutlet private weak var userEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        let userEmail = userEmailTextField.text
        let password = passwordTextField.text
        Auth.auth().createUser(withEmail: userEmail!, password: password!) { (user, error) in
            if error != nil {
                //error logging in (incorrect email/password combination)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
