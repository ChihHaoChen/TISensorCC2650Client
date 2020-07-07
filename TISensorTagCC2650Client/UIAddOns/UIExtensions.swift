//
//  UIExtensions.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/29.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit


extension UILabel   {
	convenience init(text: String, font: UIFont, numberOfLines: Int = 1, color: UIColor)    {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
		self.textColor = color
    }
}


extension UIButton  {
    convenience init(title: String, titleColor: UIColor, font: UIFont, width: CGFloat, height: CGFloat, cornerRadius: CGFloat) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.constrainWidth(constant: width)
        self.constrainHeight(constant: height)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
