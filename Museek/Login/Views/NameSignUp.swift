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
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
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
        //        let bundle = Bundle(for: type(of: self))
        //        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        let view = Bundle.main.loadNibNamed("NameSignUp", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        return view
    }
}
