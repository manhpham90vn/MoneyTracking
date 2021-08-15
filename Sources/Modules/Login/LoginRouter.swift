//
//  LoginRouter.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

protocol LoginRouterInterface {
    func toRegister()
}

final class LoginRouter: LoginRouterInterface, Router {

    unowned let viewController: LoginViewController

    required init(viewController: LoginViewController) {
        self.viewController = viewController
        viewController.presenter = LoginPresenter(view: viewController,
                                                  router: self,
                                                  interactor: LoginInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func toRegister() {
        let vc = AppScenes.register.viewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

}

