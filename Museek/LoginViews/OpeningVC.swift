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
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        let loginVC = LoginVC();
        self.present(loginVC, animated: true, completion: nil)
        print("GOT HERE")
    }
    
}
