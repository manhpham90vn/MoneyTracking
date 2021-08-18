//
//  HomeHeader.swift
//  MyApp
//
//  Created by Manh Pham on 8/17/21.
//

import UIKit

class HomeHeader: UIView, NibOwnerLoadable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var dateRange: UILabel!
    
    func config(user: User, range: DateRange, amount: Int) {
        nameLabel.text = "Username: \(user.name)"
        emailLabel.text = "Email: \(user.email)"
        totalAmountLabel.text = range == .all ? toFormatter(amount: user.totalAmount) : toFormatter(amount: amount)
        dateRange.text = range.title
    }
    
    private func toFormatter(amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: "vi_VN")
        formatter.numberStyle = .currency
        return formatter.string(from: amount as NSNumber)!
    }

}
