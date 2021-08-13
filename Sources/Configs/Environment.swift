//
//  Environment.swift
//  MyApp
//
//  Created by Manh Pham on 07/06/2021.
//

import Foundation

enum Environment {
    case develop
    case product

    var apiURL: String {
        "https://api.github.com/"
    }

}
