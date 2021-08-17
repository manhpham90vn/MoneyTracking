//
//  HomeInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol HomeInteractorInterface {
    func getAllItem(date: Date?) -> Single<[Transaction]>
    func logOut()
    func removeTransaction(transaction: Transaction) -> Single<Bool>
    func getUserInfo() -> Single<User?>
}

final class HomeInteractor: HomeInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    @Injected var auth: AuthManagerInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func getAllItem(date: Date?) -> Single<[Transaction]> {
        if let user = auth.currentUser {
            return database.allTransactions(email: user, date: date).map { obj -> [Transaction] in
                obj.map { $0.asDomain() }
            }
        }
        return .just([])
    }
    
    func logOut() {
        auth.logOut()
    }
    
    func removeTransaction(transaction: Transaction) -> Single<Bool> {
        if let user = auth.currentUser {
            return database.deleteTransaction(email: user, transaction: transaction.asRealm())
        }
        return .just(false)
    }
    
    func getUserInfo() -> Single<User?> {
        if let user = auth.currentUser {
            return database.getUserInfo(email: user).map { $0?.asDomain() }
        }
        return .just(nil)
    }

}
