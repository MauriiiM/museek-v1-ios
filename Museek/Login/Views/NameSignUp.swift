//
//  NameSignUp.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/7/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

class NameSignUp: UIView{
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let xibView =  Bundle.main.loadNibNamed("NameSignUp", owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        xibView.frame = self.bounds
    }
}
