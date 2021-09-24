//
//  TabItems.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

enum TabItem: String, CaseIterable {
    case dashboard = "Dashboard"
    case add = "Add"
    case settings = "Settings"

    var viewController: UIViewController {
        switch self {
        case .dashboard:
            let storyboard = UIStoryboard(name: "Dashboard", bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        case .settings:
            let storyboard = UIStoryboard(name: "Settings", bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        case .add:
            let storyboard = UIStoryboard(name: "AddTransaction", bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: "AddTransactionVC") as! AddTransactionVC
        }
    }

    var icon: UIImage {
        switch self {
        case .dashboard:
            return UIImage(systemName: "house.circle")!
        case .settings:
            return UIImage(systemName: "gear.circle")!
        case .add:
            return UIImage(systemName: "plus.circle")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
