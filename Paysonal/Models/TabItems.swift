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
            let storyboard = UIStoryboard(name: NibNames.dashboard, bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: NibNames.dashboard + "VC") as! DashboardVC
        case .settings:
            let storyboard = UIStoryboard(name: NibNames.settings, bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: NibNames.settings + "VC") as! SettingsVC
        case .add:
            let storyboard = UIStoryboard(name: NibNames.addTransaction, bundle: .main)
            return storyboard.instantiateViewController(withIdentifier: NibNames.addTransaction + "VC") as! AddTransactionVC
        }
    }

    var icon: UIImage {
        switch self {
        case .dashboard:
            return UIImage(systemName: AppConstants.dashIcon)!
        case .settings:
            return UIImage(systemName: AppConstants.settingsIcon)!
        case .add:
            return UIImage(systemName: AppConstants.addIcon)!
        }
    }
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
