//
//  AddViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

final class AddViewController: BaseViewController {
    
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    
    var presenter: AddPresenter!

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
            addButton
                .rx
                .tap
                .map { [weak self] in Transaction(id: UUID().uuidString,
                                                  amount: nil,
                                                  currency: nil,
                                                  content: self?.noteTextField.text,
                                                  date: Date())
                }
            ~> presenter.trigger
        ]
    }
    
}

extension AddViewController: AddViewInterface {}
