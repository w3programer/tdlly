//
//  UITextField + extension.swift
//  Zi Elengaz
//
//  Created by mahmoudhajar on 4/18/19.
//  Copyright © 2019 CreativeShare. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    
     func setRoundCorners(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
         self.clipsToBounds = true
    }
    
    /// MARK : - Change placeholder color
    
    @IBInspectable var placeHolderClor: UIColor? {
        get {
            return self.placeHolderClor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    /// MARK :- SET Padding space
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    /// Mark: - 
    
    
}
