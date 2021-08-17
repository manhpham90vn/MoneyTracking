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

enum DateRange {
    case all
    case range(date: Date)
    
    var title: String {
        switch self {
        case .all:
            return "All"
        case let .range(date):
            return "Date \(mapDateToString(date: date))"
        }
    }
    
    var date: Date? {
        switch self {
        case .all:
            return nil
        case let .range(date):
            return date
        }
    }
    
    private func mapDateToString(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM"
        return formater.string(from: date)
    }
}

extension DateRange: Equatable {
    static func == (lhs: DateRange, rhs: DateRange) -> Bool {
        switch (lhs, rhs) {
        case (.all, .all):
            return true
        case let (.range(value1), .range(value2)):
            return value1 == value2
        default:
            return false
        }
    }
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
    let selectedRange = BehaviorRelay<DateRange>(value: .all)
    let filtetedAmount = BehaviorRelay<Int>(value: 0)
    
    init(view: HomeViewInterface,
         router: HomeRouterInterface,
         interactor: HomeInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        disposeBag ~ [
            trigger
                .withUnretained(self)
                .flatMapLatest { $0.0.interactor.getAllItem(date: $0.0.selectedRange.value.date).trackActivity($0.0.headerActivityIndicator) }
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
                ~> userInfo,
            
            selectedRange
                .withUnretained(self)
                .do(onNext: { this, _ in
                    this.trigger.accept(())
                })
                .subscribe(),
            
            elements
                .withUnretained(self)
                .filter { this, _ in this.selectedRange.value.date != nil }
                .subscribe(onNext: { result in
                    var resultValue = 0
                    for element in result.1 {
                        switch element.type {
                        case .deposits:
                            resultValue += element.amount
                        case .withdrawal:
                            resultValue -= element.amount
                        }
                    }
                    result.0.filtetedAmount.accept(resultValue)
                })
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
