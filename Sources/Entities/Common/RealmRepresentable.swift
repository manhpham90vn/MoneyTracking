//
//  RealmRepresentable.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType
    func asRealm() -> RealmType
}
