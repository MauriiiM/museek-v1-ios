//
//  ProfileVC.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/4/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction fileprivate func logoutButtonPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            let sb = UIStoryboard(name: "Opening", bundle: nil)
            let vc = sb.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        } catch let logoutError {
            print(logoutError)
        }
    }
}
