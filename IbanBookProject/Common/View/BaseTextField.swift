//
//  BaseTextField.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import Foundation
import UIKit

class BaseTextField: UITextField{
    //MARK: - LIFECYCLE
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //MARK: - PRIVATE FUNCS
    
    private func commonInit() {
        layer.cornerRadius = 20
        font = .appFont()
        layer.borderWidth = 1
        backgroundColor = .clear
        borderStyle = .none
        setBackground(color: .clear)
        setBorderStyle(.none)
        setFontSize(16)
        autocorrectionType = .no
        autocapitalizationType = .words
    }
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20 , dy: 0)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 10)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20 , dy: 0)
    }
    
    func setBorderWidth(width: CGFloat) {
        self.layer.borderWidth = width
    }
    
    func setBackground(color: UIColor){
        self.backgroundColor = color
    }
    
    func setCornerRadius(width: CGFloat){
        self.layer.cornerRadius = width
    }
    
    func setBorderStyle(_ style: UITextField.BorderStyle) {
        self.borderStyle = style
    }
    
    func setBorderColor(color: CGColor) {
        let myColor = UIColor(cgColor: color).withAlphaComponent(0.5)
        self.layer.borderColor = myColor.cgColor
    }
    
    func setFontSize(_ size: CGFloat) {
           if let font = self.font {
               self.font = UIFont(name: font.fontName, size: size)
           } else {
               self.font = UIFont.systemFont(ofSize: size)
           }
        }
    func setPlaceholderColor( color: UIColor, alpha: CGFloat) {
        guard let placeholderText = self.placeholder else {
            return
        }
        
        let modifiedColor = color.withAlphaComponent(alpha)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: modifiedColor,
            .font: self.font ?? UIFont.systemFont(ofSize: 15.0)
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}



