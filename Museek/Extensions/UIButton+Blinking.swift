//
//  UIButton+Blinking.swift
//  Museek
//
//  Created by Mauricio Monsivais on 12/16/17.
//  Copyright © 2017 Museek. All rights reserved.
//

import UIKit
/**
 A button extension which allows for button to begin blinking when pressed
 - Author:
 - Note:
 guidance from "https://stackoverflow.com/questions/34666136/how-to-make-a-button-flash-or-blink"
 */
extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.bounds.contains(point) ? self : nil
    }
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}
