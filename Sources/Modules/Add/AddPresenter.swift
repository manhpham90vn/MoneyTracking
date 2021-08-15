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
    let trigger = PublishRelay<Transaction>()

    init(view: AddViewInterface,
         router: AddRouterInterface,
         interactor: AddInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        disposeBag ~ [
            trigger
                .withUnretained(self)
                .flatMapLatest { vc, obj -> Observable<Void> in
                    return vc.interactor.addNewTransaction(transaction: obj)
                        .asObservable()
                        .flatMap { result -> Observable<Void> in
                            if result {
                                return vc.view.showAlert(title: "Success", message: "")
                                    .do(onNext: {
                                        vc.router.back()
                                    })
                            } else {
                                return vc.view.showAlert(title: "Error", message: "")
                            }
                        }
                }
                .subscribe()
        ]
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: router as AnyObject)
        LeakDetector.instance.expectDeallocate(object: interactor as AnyObject)
    }

}
