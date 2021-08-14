//
//  AddRouter.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

protocol AddRouterInterface {
    func back()
}

final class AddRouter: AddRouterInterface, Router {

    unowned let viewController: AddViewController

    required init(viewController: AddViewController) {
        self.viewController = viewController
        viewController.presenter = AddPresenter(view: viewController,
                                                router: self,
                                                interactor: AddInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func back() {
        viewController.navigationController?.popViewController(animated: true)
    }

}

