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
    func getUserInfo(email: String) -> Single<RMUser?>
    func login(email: String) -> Single<Bool>
    func allTransactions(email: String, date: Date?) -> Single<[RMTransaction]>
    func createTransaction(email: String, transaction: RMTransaction) -> Single<Bool>
    func updateTransaction(email: String, transaction: RMTransaction) -> Single<Bool>
    func deleteTransaction(email: String, transaction: RMTransaction) -> Single<Bool>
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
    
    func getUserInfo(email: String) -> Single<RMUser?> {
        Single<RMUser?>.create { [weak self] single in
            if let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                single(.success(user))
            } else {
                single(.success(nil))
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
    
    func allTransactions(email: String, date: Date?) -> Single<[RMTransaction]> {
        Single<[RMTransaction]>.create { [weak self] single in
            if let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                if let date = date {
                    let transaction = user.transactions.filter("date BETWEEN %@", [date.startOfMonth(), date.endOfMonth()])
                    single(.success(Array(transaction)))
                } else {
                    single(.success(Array(user.transactions)))
                }
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
                    switch transaction.type {
                    case .deposits:
                        user.totalAmount += transaction.amount
                    case .withdrawal:
                        user.totalAmount -= transaction.amount
                    }
                    single(.success(true))
                }
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
    
    func updateTransaction(email: String, transaction: RMTransaction) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if let transactionToUpdate = self?.realm?.object(ofType: RMTransaction.self, forPrimaryKey: transaction.id),
               let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                try? self?.realm?.write {
                    switch transactionToUpdate.type {
                    case .deposits:
                        user.totalAmount -= transactionToUpdate.amount
                    case .withdrawal:
                        user.totalAmount += transactionToUpdate.amount
                    }
                    switch transaction.type {
                    case .deposits:
                        user.totalAmount += transaction.amount
                    case .withdrawal:
                        user.totalAmount -= transaction.amount
                    }
                    transactionToUpdate.currency = transaction.currency
                    transactionToUpdate.type = transaction.type
                    transactionToUpdate.amount = transaction.amount
                    transactionToUpdate.content = transaction.content
                    transactionToUpdate.date = transaction.date
                    self?.realm?.add(user, update: .modified)
                    self?.realm?.add(transactionToUpdate, update: .modified)
                    single(.success(true))
                }
            } else {
                single(.success(false))
            }
            return Disposables.create()
        }
    }
    
    func deleteTransaction(email: String, transaction: RMTransaction) -> Single<Bool> {
        Single<Bool>.create { [weak self] single in
            if let transaction = self?.realm?.object(ofType: RMTransaction.self, forPrimaryKey: transaction.id),
               let user = self?.realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
                try? self?.realm?.write {
                    switch transaction.type {
                    case .deposits:
                        user.totalAmount -= transaction.amount
                    case .withdrawal:
                        user.totalAmount += transaction.amount
                    }
                    self?.realm?.add(user, update: .modified)
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
