//
//  RMTransaction.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

final class RMTransaction: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var amount: Int
    @Persisted var currency: Currency
    @Persisted var type: TransactionType
    @Persisted var content: String
    @Persisted var date: Date
}

extension RMTransaction: DomainConvertibleType {
    func asDomain() -> Transaction {
        Transaction(id: id, amount: amount, currency: currency, type: type, content: content, date: date)
    }
}

extension Transaction: RealmRepresentable {
    func asRealm() -> RMTransaction {
        RMTransaction().then {
            $0.id = id
            $0.amount = amount
            $0.currency = currency
            $0.type = type
            $0.content = content
            $0.date = date
        }
    }
}
