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
                .flatMapLatest { vc, obj -> Observable<Void> in
                    if obj.isValidEmail() {
                        return vc.interactor.login(email: obj)
                            .asObservable()
                            .flatMap { result -> Observable<Void> in
                                if result {
                                    return vc.view
                                        .showAlert(title: "OK", message: "Đăng Nhập Thành Công")
                                        .do(onNext: {
                                            vc.interactor.saveUser(email: obj)
                                            vc.router.toHome()
                                        })
                                } else {
                                    return vc.view.showAlert(title: "OK", message: "Đăng nhập thất bại")
                                }
                            }
                    } else {
                        return vc.view.showAlert(title: "ERROR", message: "sai dinh dang")
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
