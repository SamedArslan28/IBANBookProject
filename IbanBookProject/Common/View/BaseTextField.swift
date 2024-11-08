//
//  BaseTextField.swift
//  IbanBookProject
//
//  Created by Abdulsamed Arslan on 27.10.2023.
//

import UIKit

final class BaseTextField: UITextField{

    //MARK: - LIFECYCLE
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - INIT

    private func commonInit() {
        setBackground(color: .clear)
        setBorderStyle(.none)
        setFontSize(16)
        prepareUI()
    }

    //MARK: - PRIVATE FUNCS

    private func prepareUI() {
        layer.cornerRadius = 20
        font = .appFont()
        layer.borderWidth = 1
        backgroundColor = .clear
        borderStyle = .none
        autocorrectionType = .no
        autocapitalizationType = .words
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20 , dy: 0)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 10)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20 , dy: 0)
    }
    
    func setBorderWidth(width: CGFloat) {
        layer.borderWidth = width
    }
    
    func setBackground(color: UIColor){
        backgroundColor = color
    }
    
    func setCornerRadius(width: CGFloat){
        layer.cornerRadius = width
    }
    
    func setBorderStyle(_ style: UITextField.BorderStyle) {
        borderStyle = style
    }
    
    func setBorderColor(color: CGColor) {
        let myColor = UIColor(cgColor: color).withAlphaComponent(0.5)
        layer.borderColor = myColor.cgColor
    }
    
    func setFontSize(_ size: CGFloat) {
        if let font = self.font {
            self.font = UIFont(name: font.fontName, size: size)
        } else {
            self.font = UIFont.systemFont(ofSize: size)
        }
    }
}



