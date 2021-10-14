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
    public static let nothingToShow = "Nothing to show yet!"
    public static let transactionHistoryTitle = "Transaction History"
    public static let fetchingError = "Could not fetch data!"
    public static let delete = "Delete"
    public static let verifyDeleteTx = "Are you sure you want to delete this transaction? this cannot be undone"

    // MARK: - Category
    public static let chooseCategory = "Select a category"
    public static let chooseSource = "Select a source of income"
    public static let newCategoryAlertTitle = "Enter name of the category"
    public static let newCategoryAlertBody = "Name your category!"
    public static let errorTitle = "Oopps!"
    public static let alertTitle = "Heads up!"
    public static let categoryExists = "Seems like that name already exists, try another one!"
    public static let newCategory = "New category"
    public static let newSource = "New source"
    public static let categoryError = "Category can't be empty!"
    public static let amountError = "Amount can't be empty!"
    public static let dateError = "Please choose a date"
    public static let color = "Color"
    public static let colorError = "Please choose a color"
    public static let somethingWentWrong = "Something went wrong! please try again"
    public static let sourceRequest = "Please enter the name of your new source of income"
    public static let sourceExists = "This source of income already exists!"
    public static let sourceError = "Source of income can't be empty!"
    public static let fundsAmountError = "Amount of funds can't be empty!"

    // MARK: - Register
    public static let nameTitle = "Your name (optional)"
    public static let emailTitle = "Your email"
    public static let passwordTitle = "Create a string password"
    public static let registerTitle = "Register"
    public static let emailError = "Please enter a valid email"
    public static let passwordError = "Password must be 8 characters long and contain at least 1 number and 1 special character "

    // MARK: - Login
    public static let welcomeAnonymous = "Welcome to\nPaysonal!"
    public static let welcomeUser = "Welcome back,\n%@"
    public static let signInUser = "Enter password to sign in to %@"
    public static let errorLogin = "Email or password are invalid"
    public static let resetPasswordAlert = "Are you sure you want to reset your password?"
    public static let reset = "Reset"
    public static let resetAlertTitle = "Email sent"
    public static let resetAlertMsg = "An email was sent to your address"

    // MARK: - Choose Date

    public static let errorLoading = "There was an error loading your transaction history"

    // MARK: - Settings
    public static let nameChange = "What would you like us to call you?"
    public static let cancel = "Cancel"
    public static let confirm = "Confirm"
    public static let logoutTitle = "Logout"
    public static let logoutMsg = "Are you sure you want to log out?"
    public static let contactEmail = "info@Paysonal.net"

    // MARK: - Edit categories
    public static let emptyCatErr = "Category cannot be empty!"
    public static let verifyDeleteCat = "Are you sure you want to delete this category?\nThis will not delete transactions"

    // MARK: - Segue ID's
    public static let showDashboard: String = "showDashboard"
    public static let showCategoryAlert: String = "showNewCategoryAlert"
    public static let showLogin: String = "showLogin"
}
