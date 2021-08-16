//
//  RMUser.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

final class RMUser: Object {
    @Persisted(primaryKey: true) var email: String
    @Persisted var name: String
    @Persisted var transactions: List<RMTransaction>
    @Persisted var totalAmount: Int
}

extension RMUser: DomainConvertibleType {
    func asDomain() -> User {
        User(email: email, name: name, transactions: transactions.map { $0.asDomain() }, totalAmount: totalAmount)
    }
}

extension User: RealmRepresentable {
    func asRealm() -> RMUser {
        RMUser().then {
            $0.email = email
            $0.name = name
            $0.transactions.append(objectsIn: transactions.map { $0.asRealm() })
            $0.totalAmount = totalAmount
        }
    }
}
