//
//  DomainConvertibleType.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation

protocol DomainConvertibleType {
    associatedtype DomainType
    func asDomain() -> DomainType
}
