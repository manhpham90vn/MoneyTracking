//
//  LoginInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol LoginInteractorInterface {

}

final class LoginInteractor: LoginInteractorInterface {

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}
