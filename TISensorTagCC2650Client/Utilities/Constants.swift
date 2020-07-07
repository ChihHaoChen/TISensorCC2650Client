//
//  Constants.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/03.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit
import CoreBluetooth

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}


enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale

    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}


enum UUID {
	static let initUUID = CBUUID.init(string: "AA80")
	
	static let serviceLight = CBUUID.init(string: "F000AA70-0451-4000-B000-000000000000")
	static let charLightConfig = CBUUID.init(string: "F000AA72-0451-4000-B000-000000000000")
	static let charLightData = CBUUID.init(string: "F000AA71-0451-4000-B000-000000000000")
	
	static let serviceTemp = CBUUID.init(string: "F000AA00-0451-4000-B000-000000000000")
	static let charTempConfig = CBUUID.init(string: "F000AA02-0451-4000-B000-000000000000")
	static let charTempData = CBUUID.init(string: "F000AA01-0451-4000-B000-000000000000")
	
	static let serviceIO = CBUUID.init(string: "F000AA64-0451-4000-B000-000000000000")
	static let charIOConfig = CBUUID.init(string: "F000AA66-0451-4000-B000-000000000000")
	static let charIOData = CBUUID.init(string: "F000AA65-0451-4000-B000-000000000000")
	
	static let serviceKeys = CBUUID.init(string: "FFE0")
	static let charKeys = CBUUID.init(string: "FFE1")
}


enum Margin {
	static let paddingBottom: CGFloat = 16
}
