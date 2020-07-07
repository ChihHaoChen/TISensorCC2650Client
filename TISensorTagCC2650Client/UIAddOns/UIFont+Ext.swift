//
//  UIFont+Ext.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/29.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

extension UIFont {
	
	func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
	
	
	func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

	
	func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
