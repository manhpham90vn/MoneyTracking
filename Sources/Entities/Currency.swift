//
//  Currency.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import Foundation
import RealmSwift

@objc
enum Currency: Int, PersistableEnum {
    case japanse
    case thai
    case vnd
    
    var name: String {
        switch self {
        case .japanse:
            return "Japanese Yen"
        case .thai:
            return "Thai Baht"
        case .vnd:
            return "Vietnamese Dong"
        }
    }
    
    var symbol: String {
        switch self {
        case .japanse:
            return "円"
        case .thai:
            return "฿"
        case .vnd:
            return "₫"
        }
    }
    
    var locate: Locale {
        switch self {
        case .japanse:
            return .init(identifier: "ja_JP")
        case .thai:
            return .init(identifier: "th_TH")
        case .vnd:
            return .init(identifier: "vi_VN")
        }
    }
}
