//
//  UserPreferences.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation
import FirebaseFirestore

public class UserPreferences {

    // MARK: - Variables

    private(set) static var shared: UserPreferences?
    private var categories: [Category] = []

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserPreferences() }
    }

    // MARK: - private methods

    private func setUserID(id: String) {
        UserDefaults.standard.setValue(id, forKey: AppConstants.kUserId)
    }

    private func setUserEmail(with email: String) {
        UserDefaults.standard.setValue(email, forKey: AppConstants.kUserEmail)
    }

    private func setUsername(with name: String) {
        UserDefaults.standard.setValue(name, forKey: AppConstants.kUserName)
    }

    // MARK: - public methods

    public func isUserRegistered() -> Bool {
        if let _ = UserDefaults.standard.string(forKey: AppConstants.kUserEmail) {
            return true
        }
        return false
    }

    public func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserId)
    }

    public func resetUser() {
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserEmail)
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserName)
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserId)
    }

    public func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserEmail)
    }

    public func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserName)
    }

    /// Add a category to the categories array, checking that it doesn't exist before
    /// - Parameter category: String name of category
    /// - returns Bool specifying weather it was added successfully or not
    public func addNewCategory(newCategory: Category) -> Bool {
        if !self.categories.contains(where: {$0.name.lowercased() == newCategory.name.lowercased()}) {
            self.categories.append(newCategory)
            return true
        }
        return false
    }

    public func getCategories() -> [Category] {
        return self.categories
    }

    public func registerUserToFirebase() {
        let db = Firestore.firestore()
        db.collection(AppConstants.kUsers).document(self.getUserID()!).setData([:])
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .collection(AppConstants.kYears)
            .document(Date().getCurrentYear())
            .collection(AppConstants.kMonths)
            .document(Date().getCurrentMonth())
            .setData([:])
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .collection(AppConstants.kMonths)
            .document(Date().getCurrentMonth())
            .collection(AppConstants.kTransactions)
    }

    public func registerUser(email: String, userID: String, name: String?) {
        self.setUserID(id: userID)
        self.setUserEmail(with: email)
        if name != nil { self.setUsername(with: name!) }
        self.registerUserToFirebase()
    }

    public func loginUser(email: String, userID: String ){
        self.setUserEmail(with: email)
        self.setUserID(id: userID)
    }

}
