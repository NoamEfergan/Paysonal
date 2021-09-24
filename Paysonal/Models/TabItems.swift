//
//  TabItems.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

enum TabItem: String, CaseIterable {
    case dashboard = "Dashboard"
    case settings = "Settings"

    var viewController: UIViewController {
        switch self {
        case .dashboard:
            let storyboard = UIStoryboard(name: "Dashboard", bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
        case .settings:
            let storyboard = UIStoryboard(name: "Settings", bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        }
    }

    var icon: UIImage {
        switch self {
        case .dashboard:
            return UIImage(systemName: "house.circle")!
        case .settings:
            return UIImage(systemName: "gear.circle")!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
