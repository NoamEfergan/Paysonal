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
