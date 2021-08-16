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
            ~> elements
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
