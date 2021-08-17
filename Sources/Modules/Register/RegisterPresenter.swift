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
    let trigger = PublishRelay<User>()

    init(view: RegisterViewInterface,
         router: RegisterRouterInterface,
         interactor: RegisterInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        disposeBag ~ [
            trigger
                .withUnretained(self)
                .flatMapLatest { this, obj -> Observable<Void> in
                    if obj.isValid() {
                        return this.interactor.createUser(user: obj)
                            .asObservable()
                            .flatMap { result -> Observable<Void> in
                                if result {
                                    return this.view
                                        .showAlert(title: "Success", message: "Create user success")
                                        .do(onNext: {
                                            this.router.back()
                                        })
                                } else {
                                    return this.view
                                        .showAlert(title: "Error", message: "User Exits")
                                }
                            }
                    } else {
                        return this.view
                            .showAlert(title: "Error", message: "Please check email and name")
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

extension User {
    fileprivate func isValid() -> Bool {
        return email.isValidEmail() && !name.isEmpty
    }
}
