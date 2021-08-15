//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class RegisterViewController: BaseViewController {
    
    var presenter: RegisterPresenter!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
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
            registerButton
                .rx
                .tap
                .map { [weak self] in User(email: self?.emailTextField.text ?? "",
                                           name: self?.nameTextField.text,
                                           transactions: nil)
                }
                ~> presenter.trigger
        ]
    }
    
}

extension RegisterViewController: RegisterViewInterface {}
