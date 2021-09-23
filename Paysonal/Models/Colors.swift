//
//  Colors.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

struct AppColors {

    public static var tintColor: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor(hex: "#0bf492")
            } else {
                /// Return the color for Light Mode
                return UIColor(hex: "#ff3378")
            }
        }
    }()
}
