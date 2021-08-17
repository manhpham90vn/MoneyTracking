//
//  AppScenes.swift
//  VIPPER
//
//  Created by Manh Pham on 06/06/2021.
//

enum AppScenes {
    case home
    case add(mode: AddEditMode)
    case login
    case register
    
    var viewController: UIViewController {
        switch self {
        case .home:
            let vc = StoryboardScene.HomeViewController.initialScene.instantiate()
            vc.title = "Home"
            let vcInjected = HomeRouter(viewController: vc).viewController
            return vcInjected
        case let .add(mode):
            let vc = StoryboardScene.AddViewController.initialScene.instantiate()
            let vcInjected = AddRouter(viewController: vc).viewController
            vcInjected.title = mode.title
            vcInjected.presenter.mode = mode
            return vcInjected
        case .login:
            let vc = StoryboardScene.LoginViewController.initialScene.instantiate()
            vc.title = "Login"
            let vcInjected = LoginRouter(viewController: vc).viewController
            return vcInjected
        case .register:
            let vc = StoryboardScene.RegisterViewController.initialScene.instantiate()
            vc.title = "Register"
            let vcInjected = RegisterRouter(viewController: vc).viewController
            return vcInjected
        }
    }
}
