//
//  EmailSignup.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/27/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailSignup: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    fileprivate var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LocationSignUp {// do the check because there's 2 segues
            let locSignUpVC = segue.destination as! LocationSignUp
            locSignUpVC.user = self.user
        }
    }
    
    @IBAction func unwindToEmailVC(_ sender: UIStoryboardSegue){
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @IBAction func nextButtonPressed(_ sender: RoundedButton) {
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            isAvailable(email: email, callback:{ available  in
                if available {
                    if self.isValid(emailString: email) {
                        if let user = self.user { user.changeEmail(to: email) } //user was previously set and new email was entered
                        else { self.user = User(withEmail: email) }
                        self.performSegue(withIdentifier: "toLocationSignUp", sender: self)
                    }
                } else {//email is not available
                    self.presentEmailAlert()
                    
                }
            })//end closure
        }
    }
    
    /**
     checks to see if email is available by attempting to sign in using a blank password,
     check if error string returns contains "17011" (error for incorrect pasword given by google
     at: https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Enums/FIRAuthErrorCode)
     -https://stackoverflow.com/questions/38676779/how-to-check-if-an-email-address-is-already-in-use-firebase/38685208
     */
    fileprivate func isAvailable(email: String, callback: @escaping (_ isAvailable: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: " ",
                           completion: { (user, error) in
                            var availability = false
                            
                            if let error = error {
                                let errStr = String(describing: error)
                                if errStr.contains("17011") {
                                    //email doesn't exist
                                    availability = true
                                }
                            }
                            callback(availability)
        })
    }
    
    //checks whether entered email is in correct email format
    fileprivate func isValid(emailString email: String)-> Bool{
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //regEx
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        
        return emailPredicate.evaluate(with: email)
    }
    
    /**
     presents an alert when typed email is taken.
     */
    fileprivate func presentEmailAlert(){
        let errorMsg = "Email is linked to an account."
        let alert = UIAlertController(title: "Email Unavailable", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
