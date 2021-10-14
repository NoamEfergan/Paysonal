//
//  UserPreferences.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation
import FirebaseFirestore
import Combine

public class UserPreferences {

    // MARK: - Variables

    private(set) static var shared: UserPreferences?
    private let db = Firestore.firestore()
    private var categories: [Category] = []
    private var sourcesOfIncome: [String] = []

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserPreferences() }
    }

    // MARK: - private methods

    private func setSourcesOfIncomeInFirestore() {
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .setData([AppConstants.kSources: sourcesOfIncome] ,merge: true)
    }

    private func setCategoriesInFirestore() {
        var colorsArray: [String] = []
        var namesArray: [String] = []
        self.categories.forEach({
            colorsArray.append($0.colorHex)
            namesArray.append($0.name)
        })
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .setData([AppConstants.kColor: colorsArray, AppConstants.kCategory: namesArray] ,merge: true)
    }

    private func setUserID(id: String) {
        UserDefaults.standard.setValue(id, forKey: AppConstants.kUserId)
    }

    private func setUserEmail(with email: String) {
        UserDefaults.standard.setValue(email, forKey: AppConstants.kUserEmail)
    }

    private func getUsernameFromFirestore() {
        if UserDefaults.standard.string(forKey: AppConstants.kUserName) == nil {
            db.collection(AppConstants.kUsers)
                .document(self.getUserID()!)
                .getDocument(completion: { snapShot, error in
                    if error != nil {
                        self.categories = []
                        return
                    }
                    if let data = snapShot?.data(),
                       let name: String = data[AppConstants.kUserName] as? String {
                        self.setUsername(with: name)
                    }
                }
                )
        }
    }

    private func handleSnapshotToCategories(colors: [String], names: [String]) {
        self.categories = []
        for (color, name) in zip(colors, names) {
            let category = Category(name: name, colorHex: color)
            self.categories.append(category)
        }
    }

    // MARK: - User methods

    public func setUserSelectedCurrency(_ symbol: String) {
        UserDefaults.standard.set(symbol, forKey: AppConstants.kCurrency)
        NotificationCenter.default.post(name: .newCurrency, object: nil)
    }

    public func getUserSelectedCurrency() -> String {
        if let userSymbol = UserDefaults.standard.string(forKey: AppConstants.kCurrency) { return userSymbol }
        else { return "$"}
    }

    public func isUserRegistered() -> Bool {
        if let _ = UserDefaults.standard.string(forKey: AppConstants.kUserEmail) {
            return true
        }
        return false
    }

    public func setUsername(with name: String) {
        UserDefaults.standard.setValue(name, forKey: AppConstants.kUserName)
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .setData([AppConstants.kUserName: name], merge: true)
    }

    public func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserId)
    }

    public func resetUser() {
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserEmail)
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserName)
        UserDefaults.standard.removeObject(forKey: AppConstants.kUserId)
        self.categories = []
    }

    public func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserEmail)
    }

    public func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: AppConstants.kUserName)
    }

    public func registerUserToFirebase() {
        db.collection(AppConstants.kUsers).document(self.getUserID()!).setData([:])
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .setData([AppConstants.kUserName: self.getUserName() ?? ""])
    }

    public func registerUser(email: String, userID: String, name: String?) {
        self.setUserID(id: userID)
        self.setUserEmail(with: email)
        if name != nil { self.setUsername(with: name!) }
        self.registerUserToFirebase()
    }

    public func loginUser(email: String, userID: String ) {
        self.setUserEmail(with: email)
        self.setUserID(id: userID)
        self.getCategoriesFromFirestore()
        self.getSourcesOfIncomeFromFirestore()
        self.getUsernameFromFirestore()
    }


    // MARK: - Category methods

    /// Add a category to the categories array, checking that it doesn't exist before
    /// - Parameter category: String name of category
    /// - returns Bool specifying weather it was added successfully or not
    public func addNewCategory(newCategory: Category) -> Bool {
        if !self.categories.contains(where: {$0.name.lowercased() == newCategory.name.lowercased()}) {
            self.categories.append(newCategory)
            self.setCategoriesInFirestore()
            return true
        }
        return false
    }

    public func editCategory(categoryToBeEdited: Category, newName: String?, newColor: String?) -> Bool {
        guard let index = self.categories.firstIndex(where: {
            $0.name == categoryToBeEdited.name && $0.colorHex == categoryToBeEdited.colorHex
        }),
              let txManager = UserTransactionsManager.shared else { return false}
        let oldCategory = self.categories[index]
        let newCategory = Category(name: newName ?? oldCategory.name, colorHex: newColor ?? oldCategory.colorHex)
        self.categories[index] = newCategory
        self.setCategoriesInFirestore()
        return txManager.editCategoryInEntries(oldCategory: oldCategory, newCategory: newCategory)
    }

    public func getCategories() -> [Category] {
        return self.categories
    }

    public func getCategoriesFromFirestore() {
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .getDocument(completion: { snapShot, error in
                if error != nil {
                    self.categories = []
                    return
                }
                if let data = snapShot?.data(),
                   let colors: [String] = data[AppConstants.kColor] as? [String],
                   let names: [String] = data[AppConstants.kCategory] as? [String] {
                    self.handleSnapshotToCategories(colors: colors, names: names)
                }
            }
            )
    }

    // MARK: - Income methods

    public func addNewSourceOfIncome(key: String) {
        self.sourcesOfIncome.append(key)
    }

    public func addNewIncome(source: String, amount: Double) {
        let sourceOfIncome = SourceOfIncome(name: source, date: Date().getStringFromDate(), amount: amount)
        UserTransactionsManager.shared?.addSourceOfIncome(sourceOfIncome)
        setSourcesOfIncomeInFirestore()
    }

    public func removeCategory(_ cat: Category) {
        self.categories.removeAll(where: {$0 == cat})
        setCategoriesInFirestore()
    }

    public func getSources() -> [String] {
        return self.sourcesOfIncome
    }

    public func getSourcesOfIncomeFromFirestore() {
        db.collection(AppConstants.kUsers)
            .document(self.getUserID()!)
            .getDocument(completion: { snapShot, error in
                if error != nil {
                    self.sourcesOfIncome = []
                    return
                }
                if let data = snapShot?.data(),
                   let sourcesFromFirestore = data[AppConstants.kSources] as? [String] {
                    self.sourcesOfIncome = sourcesFromFirestore
                }
            })
    }
}
