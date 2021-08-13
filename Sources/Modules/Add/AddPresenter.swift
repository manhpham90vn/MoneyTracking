//
//  AddPresenter.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol AddPresenterInterface: Presenter {
    var view: AddViewInterface { get }
    var router: AddRouterInterface { get }
    var interactor: AddInteractorInterface { get }
}

final class AddPresenter: AddPresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: AddViewInterface
    let router: AddRouterInterface
    let interactor: AddInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()

    init(view: AddViewInterface,
         router: AddRouterInterface,
         interactor: AddInteractorInterface) {
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
