//
//  RealmDataBase.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation

protocol RealmDataBase {
    func createUser(user: RMUser)
    func login(user: RMUser) -> Bool
    func allTransactions(userId: String) -> [RMTransaction]
    func createTransaction(transaction: RMTransaction)
    func updateTransaction(transaction: RMTransaction)
    func deleteTransaction(transactionId: String)
}
