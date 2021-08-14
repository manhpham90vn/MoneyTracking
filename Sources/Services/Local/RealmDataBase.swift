//
//  RealmDataBase.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

protocol RealmDataBaseInterface {
    func createUser(user: RMUser)
    func login(email: String) -> Bool
    func allTransactions(email: String) -> [RMTransaction]
    func createTransaction(email: String, transaction: RMTransaction)
    func updateTransaction(transaction: RMTransaction)
    func deleteTransaction(transactionId: String)
}

final class RealmDataBase: RealmDataBaseInterface {
    
    let realm = try? Realm()
    
    init() {
        LogInfo(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")
    }
    
    func createUser(user: RMUser) {
        try? realm?.write {
            realm?.add(user)
        }
    }
    
    func login(email: String) -> Bool {
        if realm?.object(ofType: RMUser.self, forPrimaryKey: email) != nil {
            return true
        }
        return false
    }
    
    func allTransactions(email: String) -> [RMTransaction] {
        if let user = realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
            return Array(user.transactions)
        }
        return []
    }
    
    func createTransaction(email: String, transaction: RMTransaction) {
        if let user = realm?.object(ofType: RMUser.self, forPrimaryKey: email) {
            try? realm?.write {
                user.transactions.append(transaction)
            }
        }
    }
    
    func updateTransaction(transaction: RMTransaction) {
        if let id = transaction.id,
           let transactionToUpdate = realm?.object(ofType: RMTransaction.self, forPrimaryKey: id) {
            try? realm?.write {
                transactionToUpdate.amount = transaction.amount
                transactionToUpdate.content = transaction.content
            }
        }
    }
    
    func deleteTransaction(transactionId: String) {
        if let transaction = realm?.object(ofType: RMTransaction.self, forPrimaryKey: transactionId) {
            try? realm?.write {
                realm?.delete(transaction)
            }
        }
    }
}
