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

enum AddEditMode {
    case add
    case edit(transaction: Transaction)
    
    var title: String {
        switch self {
        case .add:
            return "Add Transaction"
        case .edit:
            return "Update Transaction"
        }
    }
}

final class AddPresenter: AddPresenterInterface, HasActivityIndicator, HasDisposeBag {

    unowned let view: AddViewInterface
    let router: AddRouterInterface
    let interactor: AddInteractorInterface

    let activityIndicator = ActivityIndicator()
    let trigger = PublishRelay<Transaction>()
    
    var mode: AddEditMode!
    var initCurrentcy: Currency {
        switch mode {
        case let .edit(transaction):
            return transaction.currency
        default:
            return .japanse
        }
    }
    
    var initTransactionType: TransactionType {
        switch mode {
        case let .edit(transaction):
            return transaction.type
        default:
            return .deposits
        }
    }
    
    var initDate: Date {
        switch mode {
        case let .edit(transaction):
            return transaction.date
        default:
            return Date()
        }
    }

    var uuidString: String {
        switch mode {
        case let .edit(transaction):
            return transaction.id
        default:
            return UUID().uuidString
        }
    }
    
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
                        switch this.mode {
                        case .add:
                            return this.handleAddTransaction(obj: obj)
                        case .edit:
                            return this.handleUpdateTransaction(obj: obj)
                        default:
                            return .empty()
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
    
    func handleAddTransaction(obj: Transaction) -> Observable<Void> {
        return interactor.addNewTransaction(transaction: obj)
            .asObservable()
            .withUnretained(self)
            .flatMap { this, result -> Observable<Void> in
                if result {
                    return this.view
                        .showAlert(title: "Success", message: "Add transaction success")
                        .do(onNext: { [weak this] in
                            this?.router.back()
                        })
                } else {
                    return this.view
                        .showAlert(title: "Error", message: "Add transaction failed")
                }
            }
    }
    
    func handleUpdateTransaction(obj: Transaction) -> Observable<Void> {
        return interactor.updateTransaction(transaction: obj)
            .asObservable()
            .withUnretained(self)
            .flatMap { this, result -> Observable<Void> in
                if result {
                    return this.view
                        .showAlert(title: "Success", message: "Update transaction success")
                        .do(onNext: { [weak this] in
                            this?.router.back()
                        })
                } else {
                    return this.view
                        .showAlert(title: "Error", message: "Update transaction failed")
                }
            }
    }

}

extension Transaction {
    fileprivate func isValid() -> Bool {
        return amount > 0 && !content.isEmpty
    }
}
