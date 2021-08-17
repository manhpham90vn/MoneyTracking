//
//  RegisterViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class RegisterViewController: BaseViewController {
    
    var presenter: RegisterPresenter!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var emailView: UIView!
    @IBOutlet private weak var nameView: UIView!
    
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
        nameTextField.delegate = self
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        disposeBag ~ [
            registerButton
                .rx
                .tap
                .withUnretained(self)
                .map { this, _ -> User in
                    return User(email: this.emailTextField.text ?? "",
                                name: this.nameTextField.text ?? "",
                                transactions: [],
                                totalAmount: 0)
                }
                ~> presenter.trigger
        ]
    }
    
}

extension RegisterViewController: RegisterViewInterface {}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailView.layer.borderColor = Asset.Colors.main.color.cgColor
        case nameTextField:
            nameView.layer.borderColor = Asset.Colors.main.color.cgColor
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailView.layer.borderColor = UIColor.clear.cgColor
        case nameTextField:
            nameView.layer.borderColor = UIColor.clear.cgColor
        default:
            break
        }
    }
}
