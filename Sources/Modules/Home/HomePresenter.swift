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
    
    func handleAdd()
    func handleLogOut()
}

final class HomePresenter: HomePresenterInterface, PresenterPageable {

    unowned let view: HomeViewInterface
    let router: HomeRouterInterface
    let interactor: HomeInteractorInterface

    let elements = BehaviorRelay<[Transaction]>(value: [])
    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Void>()
    let headerRefreshTrigger = PublishRelay<Void>()
    let footerLoadMoreTrigger = PublishRelay<Void>()
    let isEnableLoadMore = BehaviorRelay<Bool>(value: true)
    let isEmptyData = BehaviorRelay<Bool>(value: true)
    let headerActivityIndicator = ActivityIndicator()
    let footerActivityIndicator = ActivityIndicator()
    var currentPage: Int = 1

    let triggerRemoveAt = PublishRelay<Transaction>()
    let triggerSelect = PublishRelay<Transaction>()
    let userInfo = BehaviorRelay<User?>(value: nil)
    
    init(view: HomeViewInterface,
         router: HomeRouterInterface,
         interactor: HomeInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        disposeBag ~ [
            trigger
                .withUnretained(self)
                .flatMapLatest { $0.0.interactor.getAllItem().trackActivity($0.0.headerActivityIndicator) }
            ~> elements,
            
            triggerRemoveAt
                .withUnretained(self)
                .flatMapLatest { this, obj -> Observable<Void> in
                    return this.interactor.removeTransaction(transaction: obj)
                        .asObservable()
                        .flatMap { result -> Observable<Void> in
                            if result {
                                this.trigger.accept(())
                                return .just(())
                            } else {
                                return this.view.showAlert(title: "Error", message: "Can not delete transaction")
                            }
                        }
                }
                .subscribe(),
            
            triggerSelect
                .withUnretained(self)
                .subscribe(onNext: { this, transaction in
                    this.router.toUpdate(transaction: transaction)
                }),
            
            trigger
                .withUnretained(self)
                .flatMapLatest { this, _ -> Single<User?> in
                    return this.interactor.getUserInfo()
                }
                ~> userInfo
        ]
    }

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: router as AnyObject)
        LeakDetector.instance.expectDeallocate(object: interactor as AnyObject)
    }
    
    func handleAdd() {
        router.toAdd()
    }
    
    func handleLogOut() {
        interactor.logOut()
        router.toLogOut()
    }

}
