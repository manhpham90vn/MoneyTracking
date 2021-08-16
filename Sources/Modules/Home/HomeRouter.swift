//
//  HomeRouter.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

protocol HomeRouterInterface {
    func toAdd()
    func toLogOut()
}

final class HomeRouter: HomeRouterInterface, Router {

    unowned let viewController: HomeViewController

    required init(viewController: HomeViewController) {
        self.viewController = viewController
        viewController.presenter = HomePresenter(view: viewController,
                                                 router: self,
                                                 interactor: HomeInteractor())
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func toAdd() {
        let vc = AppScenes.add.viewController
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toLogOut() {
        let vc = AppScenes.login.viewController
        UIWindow.shared?.rootViewController = BaseNavigationController(rootViewController: vc)
    }

}

