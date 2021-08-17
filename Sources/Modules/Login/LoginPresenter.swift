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
    
    func toRegister()
}

final class LoginPresenter: LoginPresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: LoginViewInterface
    let router: LoginRouterInterface
    let interactor: LoginInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<String>()

    init(view: LoginViewInterface,
         router: LoginRouterInterface,
         interactor: LoginInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        disposeBag ~ [
            trigger
                .withUnretained(self)
                .flatMapLatest { this, obj -> Observable<Void> in
                    if obj.isValidEmail() {
                        return this.interactor.login(email: obj)
                            .asObservable()
                            .flatMap { result -> Observable<Void> in
                                if result {
                                    return this.view
                                        .showAlert(title: "OK", message: "Login Success")
                                        .do(onNext: {
                                            this.interactor.saveUser(email: obj)
                                            this.router.toHome()
                                        })
                                } else {
                                    return this.view.showAlert(title: "OK", message: "Login failed")
                                }
                            }
                    } else {
                        return this.view.showAlert(title: "Error", message: "Email invalidate")
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
    
    func toRegister() {
        router.toRegister()
    }

}
