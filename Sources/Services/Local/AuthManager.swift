//
//  AuthManager.swift
//  VIPER
//
//  Created by Manh Pham on 3/2/21.
//

import Foundation
import SwiftyUserDefaults

protocol AuthManagerInterface: AnyObject {
    var token: String? { get set }
    var currentUser: String? { get set }
    var isLogin: Bool { get }

    func logOut()
}

extension DefaultsKeys {
    var token: DefaultsKey<String?> {
        .init("token", defaultValue: nil)
    }
    var currentUser: DefaultsKey<String?> {
        .init("currentUser", defaultValue: nil)
    }
}

final class AuthManager: AuthManagerInterface {

    @SwiftyUserDefault(keyPath: \.token, options: .cached)
    var token: String?

    @SwiftyUserDefault(keyPath: \.currentUser, options: .cached)
    var currentUser: String?
    
    var isLogin: Bool {
        return token != nil
    }
    
    func logOut() {
        token = nil
        currentUser = nil
        Defaults.removeAll()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}
