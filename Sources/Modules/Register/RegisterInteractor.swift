//
//  RegisterInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol RegisterInteractorInterface {

}

final class RegisterInteractor: RegisterInteractorInterface {

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}
