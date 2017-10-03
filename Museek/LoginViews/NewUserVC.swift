//
//  NewUserVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/2/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import Firebase

class NewUserVC: UIViewController{
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
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
