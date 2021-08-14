//
//  RegisterPresenter.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol RegisterPresenterInterface: Presenter {
    var view: RegisterViewInterface { get }
    var router: RegisterRouterInterface { get }
    var interactor: RegisterInteractorInterface { get }
}

final class RegisterPresenter: RegisterPresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: RegisterViewInterface
    let router: RegisterRouterInterface
    let interactor: RegisterInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()

    init(view: RegisterViewInterface,
         router: RegisterRouterInterface,
         interactor: RegisterInteractorInterface) {
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
