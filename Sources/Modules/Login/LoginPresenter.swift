//
//  LoginPresenter.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol LoginPresenterInterface: Presenter {
    var view: LoginViewInterface { get }
    var router: LoginRouterInterface { get }
    var interactor: LoginInteractorInterface { get }
}

final class LoginPresenter: LoginPresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: LoginViewInterface
    let router: LoginRouterInterface
    let interactor: LoginInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()

    init(view: LoginViewInterface,
         router: LoginRouterInterface,
         interactor: LoginInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: router as AnyObject)
        LeakDetector.instance.expectDeallocate(object: interactor as AnyObject)
    }

}
