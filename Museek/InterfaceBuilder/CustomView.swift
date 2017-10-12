//
//  CustomView.swift
//  Museek
//
//  Created by Mauricio Monsivais on 10/11/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

//@TODO figure out how to make this parent of both SignUp.swift
class CustomView: UIView {
    //CONSTRUCTOR NEEDED FOR IBDESIGNABLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        show(view: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        show(view: "")
    }
    
    private func show(view: String) {
        let xibView = viewFromNib(named: view)
        self.addSubview(xibView)
    }
    
    private func viewFromNib(named viewName: String) -> UIView {
        let view = Bundle.main.loadNibNamed(viewName, owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        return view
    }
}
