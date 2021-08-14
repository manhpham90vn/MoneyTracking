//
//  AddInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol AddInteractorInterface {
    func addNewTransaction(transaction: Transaction)
}

final class AddInteractor: AddInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    @Injected var auth: AuthManagerInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func addNewTransaction(transaction: Transaction) {
        if let user = auth.currentUser {
            database.createTransaction(email: user, transaction: transaction.asRealm())
        }
    }

}
