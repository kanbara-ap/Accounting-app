//
//  ExtensionTextField.swift
//  Accounting app
//
//  Created by WEBSYSTEM-MAC31 on 2022/05/20.
//

import Foundation

import UIKit

extension UITextField{
    var textToInt: Int{
        let text = self.text
        let int = text.flatMap{Int($0)} ?? 0
        return int
    }
}
