//
//  BaseView.swift
//  VIPPER
//
//  Created by Manh Pham on 06/06/2021.
//

protocol BaseView: AnyObject {
    func showAlert(title: String, message: String) -> Observable<Void>
    func showAlertConfirm(title: String, message: String) -> Observable<Void>
}

extension BaseView {
    func showAlert(title: String, message: String) -> Observable<Void> {
        AppHelper.shared.showAlert(title: title, message: message)
    }
    func showAlertConfirm(title: String, message: String) -> Observable<Void> {
        AppHelper.shared.showAlertConfirm(title: title, message: message)
    }
}
