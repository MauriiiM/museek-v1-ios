//
//  RegisterVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/3/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController{
    @IBOutlet fileprivate weak var password: UITextField!
    fileprivate var _user: User!
    var user: User! {
        get{ return _user }
        set{ _user = newValue }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction fileprivate func finishedTypingUsername(_ sender: UITextField) {
        if let username = sender.text {
            _user.username = username
        }
    }
    
    @IBAction fileprivate func createAccountButtonPressed(sender: UIButton) {
        if let pswrd = password.text {
            
            Api.User.create(user: user, withPassword: pswrd){ (newUser, error) in
                if error == nil {
                    Api.User.CURRENT_USER = newUser
                    self.performSegue(withIdentifier: "toMainSb", sender: self)
                } else {
                    let errorMsg = error?.localizedDescription
                    let alert = UIAlertController(title: error?.localizedDescription, message: errorMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
