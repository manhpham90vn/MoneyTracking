//
//  TransactionType.swift
//  MyApp
//
//  Created by Manh Pham on 8/16/21.
//

import Foundation
import RealmSwift

@objc
enum TransactionType: Int, PersistableEnum {
    case deposits
    case withdrawal
    
    var title: String {
        switch self {
        case .deposits:
            return "Deposits"
        case .withdrawal:
            return "Withdrawal"
        }
    }
    
    var `operator`: String {
        switch self {
        case .deposits:
            return "+"
        case .withdrawal:
            return "-"
        }
    }
}
