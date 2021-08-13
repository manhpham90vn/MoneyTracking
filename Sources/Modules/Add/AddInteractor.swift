//
//  AddInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol AddInteractorInterface {

}

final class AddInteractor: AddInteractorInterface {

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}
