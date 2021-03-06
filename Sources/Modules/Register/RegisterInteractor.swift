//
//  RegisterInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

protocol RegisterInteractorInterface {
    func createUser(user: User) -> Single<Bool>
}

final class RegisterInteractor: RegisterInteractorInterface {

    @Injected var database: RealmDataBaseInterface
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }
    
    func createUser(user: User) -> Single<Bool> {
        database.createUser(user: user.asRealm())
    }

}
