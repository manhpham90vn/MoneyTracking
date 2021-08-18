//
//  HomeTableViewCell.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class HomeTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    func config(transaction: Transaction) {
        contentLabel.text = "Content: \(transaction.content)"
        dateLabel.text = "Date: \(mapDateToString(date: transaction.date))"
        amountLabel.text = "Amount: \(transaction.type.operator)\(toFormatter(amount: transaction.amount, type: transaction.currency))"
    }
    
    private func mapDateToString(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        return formater.string(from: date)
    }
    
    private func toFormatter(amount: Int, type: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.locale = type.locate
        formatter.numberStyle = .currency
        return formatter.string(from: amount as NSNumber)!
    }
    
}
