//
//  BottomTabBarController.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

class BottomTabBarController: UITabBarController, UITabBarControllerDelegate {

    // MARK: - Life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = AppColors.tintColor
        setItems()
        addShadow()
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

    private func addShadow() {
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.cornerRadius = AppConstants.cornerRadTabBar
        self.tabBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] 
        tabBar.layer.shadowOpacity = Float(AppConstants.shadowOpacity)
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = AppConstants.shadowRad
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = .systemBackground
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddTransactionVC {
            let storyboard = UIStoryboard(name: NibNames.addTransaction, bundle: .main)
            let popupVC = storyboard.instantiateViewController(withIdentifier: NibNames.addTransaction + "VC") as! AddTransactionVC
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.modalTransitionStyle = .crossDissolve
            tabBarController.present(popupVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
