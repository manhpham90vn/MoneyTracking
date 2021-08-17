//
//  AddInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol AddInteractorInterface {
    func addNewTransaction(transaction: Transaction) -> Single<Bool>
    func updateTransaction(transaction: Transaction) -> Single<Bool>
}

final class AddInteractor: AddInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    @Injected var auth: AuthManagerInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func addNewTransaction(transaction: Transaction) -> Single<Bool> {
        if let user = auth.currentUser {
            return database.createTransaction(email: user, transaction: transaction.asRealm())
        } else {
            return .just(false)
        }
    }
    
    func updateTransaction(transaction: Transaction) -> Single<Bool> {
        if let user = auth.currentUser {
            return database.updateTransaction(email: user, transaction: transaction.asRealm())
        } else {
            return .just(false)
        }
    }

}
