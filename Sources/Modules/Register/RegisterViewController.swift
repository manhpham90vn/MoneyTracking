//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class RegisterViewController: BaseViewController {
    
    var presenter: RegisterPresenter!

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

extension RegisterViewController: RegisterViewInterface {}
