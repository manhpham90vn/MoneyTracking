//
//  AddViewController.swift
//  MyApp
//
//  Created by Manh Pham on 8/13/21.
//

import UIKit

final class AddViewController: BaseViewController {
    
    private let datePicker = UIDatePicker().then {
        $0.calendar = Calendar(identifier: .gregorian)
        $0.datePickerMode = .date
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }
    
    private let selectCurrency = BehaviorRelay<Currency>(value: .japanse)
    private let selectTransactionType = BehaviorRelay<TransactionType>(value: .deposits)
    private let selectDate = BehaviorRelay<Date>(value: Date())
    
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var currencyStackView: UIStackView!
    @IBOutlet private weak var currencyStackViewHeightCT: NSLayoutConstraint!
    @IBOutlet private weak var transactionTypeStackView: UIStackView!
    @IBOutlet private weak var transactionTypeStackViewHeightCT: NSLayoutConstraint!
    
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
        
        Currency.allCases.forEach {
            let subview = SelectableView()
            subview.isSelect = $0 == selectCurrency.value
            subview.title = "\($0.name) - \($0.symbol)"
            subview.tag = $0.rawValue
            subview.onClick = { [weak self] tag in
                guard let self = self else { return }
                self.selectCurrency.accept(Currency(rawValue: tag)!)
            }
            currencyStackView.addArrangedSubview(subview)
            subview.trailingAnchor.constraint(equalTo: currencyStackView.trailingAnchor).isActive = true
        }
        currencyStackViewHeightCT.constant = CGFloat(Currency.allCases.count * 25)
        
        TransactionType.allCases.forEach {
            let subview = SelectableView()
            subview.isSelect = $0 == selectTransactionType.value
            subview.title = $0.title
            subview.tag = $0.rawValue
            subview.onClick = { [weak self] tag in
                guard let self = self else { return }
                self.selectTransactionType.accept(TransactionType(rawValue: tag)!)
            }
            transactionTypeStackView.addArrangedSubview(subview)
            subview.trailingAnchor.constraint(equalTo: transactionTypeStackView.trailingAnchor).isActive = true
        }
        transactionTypeStackViewHeightCT.constant = CGFloat(TransactionType.allCases.count * 25)
        dateTextField.inputView = datePicker
        dateTextField.addDoneOnKeyboardWithTarget(self, action: #selector(handleSelectDate))
    }    

    override func bindDatas() {
        super.bindDatas()
        
        presenter.bind(isLoading: isLoading)
        
        disposeBag ~ [
            addButton.rx.tap
                .withUnretained(self)
                .map { this, _ -> Transaction in
                    return Transaction(id: UUID().uuidString,
                                       amount: Int(this.amountTextField.text ?? "0") ?? 0,
                                       currency: this.selectCurrency.value,
                                       type: this.selectTransactionType.value,
                                       content: this.contentTextField.text ?? "",
                                       date: this.selectDate.value)
                }
            ~> presenter.trigger,
            selectDate.map(mapDateToString) ~> dateTextField.rx.text
        ]
    }
    
    private func mapDateToString(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        return formater.string(from: date)
    }
    
    @objc
    func handleSelectDate() {
        selectDate.accept(datePicker.date)
        dateTextField.endEditing(true)
    }
    
}

extension AddViewController: AddViewInterface {}
