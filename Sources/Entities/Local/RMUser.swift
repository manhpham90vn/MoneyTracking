//
//  RMUser.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

final class RMUser: Object {
    @Persisted(primaryKey: true) var id: String?
    @Persisted var name: String?
    @Persisted var transactions: List<RMTransaction>
}

extension RMUser: DomainConvertibleType {
    func asDomain() -> User {
        User(id: id, name: name, transactions: transactions.map { $0.asDomain() })
    }
}

extension User: RealmRepresentable {
    func asRealm() -> RMUser {
        RMUser().then {
            $0.id = id
            $0.name = name
            $0.transactions.append(objectsIn: (transactions ?? []).map { $0.asRealm() })
        }
    }
}
