//
//  UISearchBar+textColor.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 03.11.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//

import Foundation
import UIKit
extension UISearchBar {
    var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField}).first as? UITextField else { return nil }
        return textField
    }
}
