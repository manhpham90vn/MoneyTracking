//
//  AppScenes.swift
//  VIPPER
//
//  Created by Manh Pham on 06/06/2021.
//

enum AppScenes {
    case home
    case add
    case login
    case register
    
    var viewController: UIViewController {
        switch self {
        case .home:
            let vc = StoryboardScene.HomeViewController.initialScene.instantiate()
            vc.title = "Home"
            let vcInjected = HomeRouter(viewController: vc)
            return vcInjected.viewController
        case .add:
            let vc = StoryboardScene.AddViewController.initialScene.instantiate()
            vc.title = "Add Transaction"
            let vcInjected = AddRouter(viewController: vc)
            return vcInjected.viewController
        case .login:
            let vc = StoryboardScene.LoginViewController.initialScene.instantiate()
            vc.title = "Login"
            let vcInjected = LoginRouter(viewController: vc)
            return vcInjected.viewController
        case .register:
            let vc = StoryboardScene.RegisterViewController.initialScene.instantiate()
            vc.title = "Register"
            let vcInjected = RegisterRouter(viewController: vc)
            return vcInjected.viewController
        }
    }
}
