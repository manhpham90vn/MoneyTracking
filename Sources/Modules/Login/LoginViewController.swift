//
//  LoginViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    var presenter: LoginPresenter!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
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
        disposeBag ~ [
            registerButton.rx.tap ~> rx.didTapRegister,
            loginButton.rx.tap.map { [weak self] in self?.emailTextField.text ?? "" } ~> presenter.trigger
        ]
    }
    
}

extension LoginViewController: LoginViewInterface {}

extension Reactive where Base: LoginViewController {
    var didTapRegister: Binder<Void> {
        Binder(base) { vc, _ in
            vc.presenter.toRegister()
        }
    }
}
