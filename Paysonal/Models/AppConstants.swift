//
//  AppConstants.swift
//  Paysonal
//
//  Created by Noam Efergan on 25/09/2021.
//

import UIKit

struct AppConstants {
    public static let cornerRad: CGFloat = 15
    public static let cornerRadTabBar: CGFloat = 20
    public static let shadowOpacity: CGFloat = 0.7
    public static let shadowRad: CGFloat = 5
    public static let minPasswordLength = 8
    public static let KeyboardToolbar: CGFloat = 45

    public static let dashIcon: String = "house.circle"
    public static let settingsIcon: String = "gear.circle"
    public static let addIcon: String = "plus.circle"

    /// UserDefaults keys
    public static let kUserName: String = "userName"
    public static let kUserEmail: String = "userEmail"
    public static let kUserId: String = "userID"

    /// Firestore keys
    public static let kUsers: String = "users"
    public static let kMonths: String = "months"
    public static let kTransactions: String = "Transactions"
    public static let kAmount: String = "Amount"
    public static let kCategory: String = "Category"
    public static let kColor: String = "ColorHex"
}
