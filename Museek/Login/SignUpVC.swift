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
    @IBOutlet weak var nameView: NameSignUp!
    @IBOutlet weak var emailAndPasswordView: EmailSignUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.nextButton.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        emailAndPasswordView.createButton.addTarget(self, action: #selector(createAccountButtonPressed(sender:)), for: .touchUpInside)
    }
    
    //checks whether entered email is in correct email format
    private func isValid(emailString email: String)-> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //regEx
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: email)
    }
    
    @objc func nextButtonPressed(sender: UIButton){
        if let nameText = nameView.fullNameTextField.text, let userNameText = nameView.userNameTextField.text {
            
            if(!nameText.isEmpty && !userNameText.isEmpty){
                nameView.isHidden = true
                emailAndPasswordView.isHidden = false
            }
        }
    }
    
    @objc func createAccountButtonPressed(sender: UIButton) {
        if let emailText = emailAndPasswordView.emailTextField.text,
            let passwordText = emailAndPasswordView.passwordTextField.text,
            let confirmPasswordText = emailAndPasswordView.confirmPasswordTextField.text{
            
            if(!emailText.isEmpty && !passwordText.isEmpty && !confirmPasswordText.isEmpty){
                if(passwordText == confirmPasswordText) {
                    Auth.auth().createUser(withEmail: emailText, password: passwordText, completion: { (user, error) in
                        //Check that user isn't NIL
                        if let u = user {
                            // User is found, goto home screen
                            // self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                        else {
                            //Check error and show message
                        }
                        
                    })               }
            }
        }
    }
}
