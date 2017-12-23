//
//  OutlinedTextView.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/23/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit

@IBDesignable
class OutlinedTextView: UITextView, UITextViewDelegate {
    
    @IBInspectable var cornerRadius: CGFloat = 10{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
//    @IBInspectable var placeholder: String = ""{
//        didSet{
//            if self.text.isEmpty {
//                self.text = placeholder
//                self.textColor = UIColor.lightGray
//            }
//        }
//    }
}
