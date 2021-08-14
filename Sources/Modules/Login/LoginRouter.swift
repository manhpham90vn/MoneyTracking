//
//  LoginRouter.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

protocol LoginRouterInterface {
    
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

}

