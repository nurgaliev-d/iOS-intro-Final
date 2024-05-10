//
//  TextFiledWithPadding.swift
//  Events
//
//  Created by Диас Нургалиев on 08.05.2024.
//

import Foundation
import UIKit

class TextFIeldWithPadding: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
}
