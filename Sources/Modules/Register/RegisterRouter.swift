//
//  RegisterRouter.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

protocol RegisterRouterInterface {
    func back()
}

final class RegisterRouter: RegisterRouterInterface, Router {

    unowned let viewController: RegisterViewController

    required init(viewController: RegisterViewController) {
        self.viewController = viewController
        viewController.presenter = RegisterPresenter(view: viewController,
                                                     router: self,
                                                     interactor: RegisterInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func back() {
        viewController.navigationController?.popViewController(animated: true)
    }

}

