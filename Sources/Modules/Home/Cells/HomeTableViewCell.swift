//
//  HomeTableViewCell.swift
//  MyApp
//
//  Created by Manh Pham on 8/14/21.
//

import UIKit

final class HomeTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var contentLabel: UILabel!
    
    func config(transaction: Transaction) {
        contentLabel.text = transaction.content
    }
    
}
