//
//  SensorTabController.swift
//  TISensorTagCC2650Client
//
//  Created by ChihHao on 2020/06/29.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit


class SensorTabController: UITabBarController {
	

    override func viewDidLoad() {
        super.viewDidLoad()
		UITabBar.appearance().tintColor = .systemOrange
        viewControllers = [
			createNavContoller(viewController: LuxController(), title: "Lux", image: "lightbulb")
		]
    }
	
	
	// MARK: - Embed each viewController inside a navigationController
	
	fileprivate func createNavContoller(viewController: UIViewController, title: String, image: String) -> UINavigationController   {
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .systemBackground
        viewController.navigationItem.title = title
		viewController.navigationController?.navigationBar.isHidden = true

        
		let largeSymbolConfig = UIImage.SymbolConfiguration(scale: .large)
        navigationController.tabBarItem.title = title
		navigationController.tabBarItem.image = UIImage(systemName: image, withConfiguration: largeSymbolConfig)
        
        return navigationController
    }
	
	
}


