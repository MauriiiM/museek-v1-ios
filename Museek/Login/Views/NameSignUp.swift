//
//  NameSignUp.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/7/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

//@IBDesignable
class NameSignUp: UIView{
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    //CONSTRUCTOR NEEDED FOR IBDESIGNABLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        showView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        showView()
    }
    
    //checks if text fields have been filled, if so, hides view
    @IBAction func nextButtonPress(_ sender: UIButton) {
        if(!((fullNameTextField.text?.isEmpty)!)
            && !((userNameTextField.text?.isEmpty)!)){
            print("COOL")
            self.isHidden = true
        }
    }
    
    private func showView() {
        let xibView = viewFromNib()
        self.addSubview(xibView)
    }
    
    private func viewFromNib() -> UIView {
        //        let bundle = Bundle(for: type(of: self))
        //        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        
        let view = Bundle.main.loadNibNamed("NameSignUp", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        return view
    }
}
