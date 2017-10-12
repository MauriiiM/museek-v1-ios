//
//  EmailSignUp.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/9/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

//@IBDesignable
class EmailSignUp: UIView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    //CONSTRUCTOR NEEDED FOR IBDESIGNABLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        showView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        showView()
    }
    
    private func showView() {
        let xibView = viewFromNib()
        self.addSubview(xibView)
    }
    
    private func viewFromNib() -> UIView {
        let view = Bundle.main.loadNibNamed("EmailSignUp", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        return view
    }
}
