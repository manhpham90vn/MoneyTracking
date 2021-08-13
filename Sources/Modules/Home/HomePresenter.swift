//
//  HomePresenter.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol HomePresenterInterface: Presenter {
    var view: HomeViewInterface { get }
    var router: HomeRouterInterface { get }
    var interactor: HomeInteractorInterface { get }
}

final class HomePresenter: HomePresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: HomeViewInterface
    let router: HomeRouterInterface
    let interactor: HomeInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()

    init(view: HomeViewInterface,
         router: HomeRouterInterface,
         interactor: HomeInteractorInterface) {
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
