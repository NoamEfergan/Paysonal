//
//  BottomTabBarController.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

class BottomTabBarController: UITabBarController {

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = AppColors.tintColor
        setItems()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        roundCorners()
    }

    // MARK: - Private methods

    private func setItems() {
        var items: [UIViewController] = []
        for item in TabItem.allCases {
            let vc = item.viewController
            vc.tabBarItem = UITabBarItem(title: item.displayTitle, image: item.icon, selectedImage: item.icon)
            items.append(vc)
        }
        self.viewControllers = items
    }

    private func roundCorners() {
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
