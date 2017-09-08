//
//  UIRefreshControl + beginRefreshingManually.swift
//  twoja_pogoda
//
//  Created by Krzysztof Glimos on 24.08.2017.
//  Copyright © 2017 Krzysztof Glimos. All rights reserved.
//
//  reczne wyswietlanie UIRefreshControl

import Foundation
import UIKit

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let tableView = superview as? UITableView {
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        sendActions(for: UIControlEvents.valueChanged)      //od razu po tym robi sie to samo jak przy IBAction z RefreshControl
    }
}
