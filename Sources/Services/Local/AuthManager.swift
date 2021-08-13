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
    var isLogin: Bool { get }

    func logOut()
}

extension DefaultsKeys {
    var token: DefaultsKey<String?> {
        .init("token", defaultValue: nil)
    }
}

final class AuthManager: AuthManagerInterface {

    @SwiftyUserDefault(keyPath: \.token, options: .cached)
    var token: String?

    var isLogin: Bool {
        return token != nil
    }
    
    func logOut() {
        token = nil
        Defaults.removeAll()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

}
