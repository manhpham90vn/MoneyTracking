//
//  AddViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

final class AddViewController: BaseViewController {
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
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
        addButton
            .rx
            .tap
            .mapTo(Transaction(id: UUID().uuidString, amount: nil, currency: nil, content: noteTextField.text, date: nil))
        ~> presenter.trigger
        ~ disposeBag
    }
    
}

extension AddViewController: AddViewInterface {}
