//
//  LuxController.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/03.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit

class LuxController: UIViewController {
	
	public let bluetoothService = BluetoothService.shared
	
	private let luxValueLabel = UILabel(text: "Lux Value\n  0.00", font: UIFont.preferredFont(forTextStyle: .title1).bold(), numberOfLines: 2, color: .systemOrange)
	
	private var timer: Timer!
	private var countDown = 0
	private var backgroundOpacity: CGFloat = 1.0
	private let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
	

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .systemGroupedBackground
		
		bluetoothService.delegate = self
	
		configureBackground()
		
		configureUI()
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		timerActive(with: 4)
	}
	
	
	// MARK: - Configure the background image
	private func configureBackground() {
		backgroundImage.image = UIImage(named: "bulb")
		backgroundImage.contentMode = .scaleAspectFill
		view.insertSubview(backgroundImage, at: 0)
	}
	
	
	// MARK: - Configure Other UI Elements
	private func configureUI() {
		view.addSubview(luxValueLabel)
		luxValueLabel.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: Margin.paddingBottom, right: 0))
		luxValueLabel.centerXInSuperview()
		luxValueLabel.textAlignment = .center
	}
	
	
	// MARK: - An internal timer to bypass the initial wrong value
	private func timerActive(with secCountDown: Int) {
		timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
		countDown = secCountDown
	}
	
	
	@objc private func countdown() {
		countDown -= 1
		print("countDownValue = \(countDown)")
		if countDown == 0 {
			timer.invalidate()
		}
	}
}


extension LuxController: BluetoothServiceDelegate {
	
	func updateValuesInUI(value: Double) {
		var valueBuffer: Double
		valueBuffer = (countDown == 0) ? value : 0.00
		
		luxValueLabel.text = "Lux Value\n \(valueBuffer.doubleValueString)"
		
		switch valueBuffer {
			case 0..<5.0:
				backgroundOpacity = 0.9
			case 5.0..<1000:
				backgroundOpacity = 0.5
			case 1000..<2000:
				backgroundOpacity = 0.1
			default:
				backgroundOpacity = 0.0
		}
		print("backgroundOpacity = \(backgroundOpacity)")
		backgroundImage.alpha = 1 - backgroundOpacity
	}
}


extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}



