//
//  LoginInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol LoginInteractorInterface {
    func login(email: String) -> Single<Bool>
    func saveUser(email: String)
}

final class LoginInteractor: LoginInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    @Injected var auth: AuthManagerInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func login(email: String) -> Single<Bool> {
        database.login(email: email)
    }
    
    func saveUser(email: String) {
        auth.currentUser = email
    }

}
