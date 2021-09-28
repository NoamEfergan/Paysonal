//
//  AppStrings.swift
//  Paysonal
//
//  Created by Noam Efergan on 25/09/2021.
//

import Foundation

struct AppStrings {

    // MARK: - Dashboard
    public static let totalSpent = "Total spent this month: \n"
    public static let transactionHistoryTitle = "Transaction History"

    // MARK: - Category
    public static let chooseCategory = "Choose a category"
    public static let newCategoryAlertTitle = "Enter name of the category"
    public static let newCategoryAlertBody = "Name your category!"
    public static let errorTitle = "Oopps!"
    public static let categoryExists = "Seems like that name already exists, try another one!"

    // MARK: - Register
    public static let nameTitle = "Your name (optional)"
    public static let emailTitle = "Your email"
    public static let passwordTitle = "Create a string password"
    public static let registerTitle = "Register"
    public static let emailError = "Please enter a valid email"
    public static let passwordError = "Password must be 8 characters long and contain at least 1 number and 1 special character "

    // MARK: - Segue ID's
    public static let showDashboard: String = "showDashboard"
}
