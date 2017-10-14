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
    @IBOutlet private weak var nameView: NameSignUp!
    @IBOutlet private weak var emailAndPasswordView: EmailSignUp!
    
    private var userName: String?
    
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
    
    @objc private func createAccountButtonPressed(sender: UIButton) {
        if let email = emailAndPasswordView.emailTextField.text,
            let password = emailAndPasswordView.passwordTextField.text,
            let confirmPassword = emailAndPasswordView.confirmPasswordTextField.text{
            
            if(!email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty){
                if(password == confirmPassword) {
                    Auth.auth().createUser(withEmail: email,
                                           password: password,
                                           completion: { (user, error) in
                                            //Check that user isn't NIL
                                            if let u = user {
                                                //will do what's in closure AFTER account's been created
                                                let profileChange = u.createProfileChangeRequest()
                                                profileChange.displayName = self.userName
                                                profileChange.commitChanges(completion: { error in
                                                    if let e = error {
                                                        print("\n\n\nerrorrrrr")
                                                    } else {
                                                        print("\n\n\nprofile updated")
                                                    }
                                                })
                                                print("ACCOUNT CREATED \n -username-> \(String(describing: u.displayName))")
                                                // self.performSegue(withIdentifier: "goToHome", sender: self)
                                            } else {
                                                //Check error and show message
                                            }
                    })
                } else {
                    //password doesnt match
                    // self.present(UIAlertController(title: "TEST", message: "some", preferredStyle: .alert), animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func nextButtonPressed(sender: UIButton){
        if let userName = nameView.userNameTextField.text {
            self.userName = userName
            if(!userName.isEmpty){
                nameView.isHidden = true
                emailAndPasswordView.isHidden = false
            }
        }
    }
    
    @IBAction private func unwind(segue: UIStoryboardSegue){
        print("unwinded from sign in")
    }
}
