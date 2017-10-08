//
//  OpeningVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/5/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
class OpeningVC: UIViewController{
    
    //when user goes from sign up to login
    @IBAction func unwind(segue unwindSegue: UIStoryboardSegue) {
        
        switch unwindSegue.identifier! {
        case "fromSignUp":
            break
        case "fromSignIn":
            break
        default:
            //stay in openingVC
            break
        }
    }
}
