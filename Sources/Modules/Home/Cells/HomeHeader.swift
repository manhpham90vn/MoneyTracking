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
    
    func config(user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        totalAmountLabel.text = "\(user.totalAmount)"
    }

}
