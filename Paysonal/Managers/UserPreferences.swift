//
//  UserPreferences.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

public class UserPreferences {

    // MARK: - Variables

    private(set) static var shared: UserPreferences?
    private let defaultCategories = ["Housing", "Car", "Amenities"]
    private var userCategories: [String] = []

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserPreferences() }
    }

    // MARK: - public methods

    public func isUserRegistered() -> Bool {
        if let _ = UserDefaults.standard.string(forKey: AppConstants.kUserEmail) {
            return true
        }
        return false
    }

    public func resetUser() {
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserEmail)
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserName)
    }

    public func setUserEmail(with email: String) {
        UserDefaults.standard.setValue(email, forKey: AppConstants.kUserEmail)
    }

    public func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserEmail)
    }

    public func setUsername(with name: String) {
        UserDefaults.standard.setValue(name, forKey: AppConstants.kUserName)
    }

    public func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserName)
    }

    public func getDefaultCategories() -> [String] {
        return defaultCategories
    }

    public func getAllCategories() -> [String] {
        var allCategories = defaultCategories
        allCategories.append(contentsOf: userCategories)
        return allCategories
    }

    public func addNewCategory(newCategory: String) -> Bool {
        if !defaultCategories.contains(where: {$0.lowercased() == newCategory.lowercased()})
            && !userCategories.contains(where: {$0.lowercased() == newCategory.lowercased()}) {
            userCategories.append(newCategory)
            return true
        }
        return false
    }

}
