//
//  LoginViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    var presenter: LoginPresenter!
    
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    deinit {
        LogInfo("\(type(of: self)) Deinit")
        LeakDetector.instance.expectDeallocate(object: presenter as AnyObject)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        
        emailTextField.delegate = self
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        disposeBag ~ [
            registerButton.rx.tap
                ~> rx.didTapRegister,
            
            loginButton.rx.tap
                .withUnretained(self)
                .map { this, _ in this.emailTextField.text ?? "" }
                ~> presenter.trigger
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        emailView.layer.borderColor = Asset.Colors.main.color.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailView.layer.borderColor = UIColor.clear.cgColor
    }
}
