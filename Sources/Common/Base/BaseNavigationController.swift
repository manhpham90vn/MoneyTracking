//
//  BaseNavigationController.swift
//  MyApp
//
//  Created by Manh Pham on 8/16/21.
//

import Foundation

final class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(named: "main")
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.backIndicatorImage = UIImage(named: "backBtn")
        navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backBtn")
    }
    
}
