//
//  AppScenes.swift
//  VIPPER
//
//  Created by Manh Pham on 06/06/2021.
//

enum AppScenes {
    case home
    case add
    
    var viewController: UIViewController {
        switch self {
        case .home:
            let vc = StoryboardScene.HomeViewController.initialScene.instantiate()
            let vcInjected = HomeRouter(viewController: vc)
            return vcInjected.viewController
        case .add:
            let vc = StoryboardScene.AddViewController.initialScene.instantiate()
            let vcInjected = AddRouter(viewController: vc)
            return vcInjected.viewController
        }
    }
}
