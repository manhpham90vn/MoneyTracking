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
                .flatMapLatest { this, obj -> Observable<Void> in
                    if obj.isValid() {
                        return this.interactor.addNewTransaction(transaction: obj)
                            .asObservable()
                            .flatMap { result -> Observable<Void> in
                                if result {
                                    return this.view.showAlert(title: "Success", message: "Add transaction success")
                                        .do(onNext: {
                                            this.router.back()
                                        })
                                } else {
                                    return this.view.showAlert(title: "Error", message: "Add transaction failed")
                                }
                            }
                    } else {
                        return this.view.showAlert(title: "Error", message: "Please input amount and content")
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

extension Transaction {
    fileprivate func isValid() -> Bool {
        return amount > 0 && !content.isEmpty
    }
}
