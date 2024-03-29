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
    public static let tintColorName: String = "TintColor"
    public static let textColor: String = "FullButtonTextColor"

    public static let dashIcon: String = "house.circle"
    public static let settingsIcon: String = "gear.circle"
    public static let addIcon: String = "plus.circle"

    /// UserDefaults keys
    public static let kUserName: String = "userName"
    public static let kUserEmail: String = "userEmail"
    public static let kUserId: String = "userID"
    public static let kCurrency: String = "currency"
    public static let kBiometrics: String = "biometrics"
    public static let keyChain: String = "keyChainService"
    public static let hashedPass: String = "HashedPassword"

    /// Firestore keys
    public static let kYears: String = "years"
    public static let kUsers: String = "users"
    public static let kMonths: String = "months"
    public static let kTransactions: String = "Transactions"
    public static let kAmount: String = "Amount"
    public static let kCategory: String = "Category"
    public static let kSources: String = "Sources of income"
    public static let kColor: String = "ColorHex"
    public static let kEntries: String = "entries"
    public static let kName: String = "name"
    public static let kDate: String = "date"

    /// URLs
    public static let privacy: String = "https://paysonal.flycricket.io/privacy.html"
    public static let termsAndConditions: String = "https://paysonal.flycricket.io/terms.html"
}
