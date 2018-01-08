//
//  RoundedImage.swift
//  Museek
//
//  Created by Mauricio Monsivais on 1/5/18.
//  Copyright © 2018 Museek. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
