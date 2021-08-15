//
//  RealmDataBase.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

protocol RealmDataBaseInterface {
    func createUser(user: RMUser) -> Single<Bool>
    func login(email: String) -> Single<Bool>
    func allTransactions(email: String) -> Single<[RMTransaction]>
    func createTransaction(email: String, transaction: RMTransaction) -> Single<Bool>
    func updateTransaction(transaction: RMTransaction) -> Single<Bool>
    func deleteTransaction(transactionId: String) -> Single<Bool>
}

final class RealmDataBase: RealmDataBaseInterface {
    
    let realm = try? Realm()
    
    init() {
        LogInfo(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")
    }
    
    func createUser(user: RMUser) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if self?.realm?.object(ofType: RMUser.self, forPrimaryKey: user.email) != nil {
                single(.success(false))
            } else {
                try? self?.realm?.write {
                    self?.realm?.add(user)
                    single(.success(true))
                }
            }
            return Disposables.create()
        }
    }
    
    func login(email: String) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) != nil {
                single(.success(true))
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
    
    func allTransactions(email: String) -> Single<[RMTransaction]> {
        Single<[RMTransaction]>.create { [weak self] single in
            if let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                single(.success(Array(user.transactions)))
            } else {
                single(.success([]))
            }
            return Disposables.create()
        }
    }
    
    func createTransaction(email: String, transaction: RMTransaction) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                try? self?.realm?.write {
                    user.transactions.append(transaction)
                    single(.success(true))
                }
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
    
    func updateTransaction(transaction: RMTransaction) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if let transactionToUpdate = self?.realm?.object(ofType: RMTransaction.self, forPrimaryKey: transaction.id) {
                try? self?.realm?.write {
                    transactionToUpdate.amount = transaction.amount
                    transactionToUpdate.content = transaction.content
                    single(.success(true))
                }
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
    
    func deleteTransaction(transactionId: String) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if let transaction = self?.realm?.object(ofType: RMTransaction.self, forPrimaryKey: transactionId) {
                try? self?.realm?.write {
                    self?.realm?.delete(transaction)
                    single(.success(true))
                }
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
}
