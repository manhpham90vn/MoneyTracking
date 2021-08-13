//
//  HomeInteractor.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

protocol HomeInteractorInterface {

}

final class HomeInteractor: HomeInteractorInterface {

    deinit {
        LogInfo("\(type(of: self)) Deinit")
    }

}
