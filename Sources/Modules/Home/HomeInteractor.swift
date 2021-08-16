//
//  HomeInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol HomeInteractorInterface {
    func getAllItem() -> Single<[Transaction]>
    func logOut()
}

final class HomeInteractor: HomeInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    @Injected var auth: AuthManagerInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func getAllItem() -> Single<[Transaction]> {
        if let user = auth.currentUser {
            return database.allTransactions(email: user).map { obj -> [Transaction] in
                obj.map { $0.asDomain() }
            }
        }
        return .just([])
    }
    
    func logOut() {
        auth.logOut()
    }

}
