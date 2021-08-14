//
//  LoginViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    var presenter: LoginPresenter!

    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: presenter as AnyObject)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
    }
    
}

extension LoginViewController: LoginViewInterface {}
