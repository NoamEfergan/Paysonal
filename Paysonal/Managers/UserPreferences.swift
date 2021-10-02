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

    public func loginUser(email: String, userID: String ) {
        self.setUserEmail(with: email)
        self.setUserID(id: userID)
    }

    public func getYearsWithTransactions() -> Future<[String], Error> {
        return Future { promise in
            guard let userID = self.getUserID() else {
                let error = NSError(domain: "No userID", code: 1, userInfo: nil)
                promise(.failure(error))
                return
            }
            self.db
                .collection(AppConstants.kUsers)
                .document(userID)
                .collection(AppConstants.kYears)
                .getDocuments { snapShot, error in
                    if error != nil {
                        let error = NSError(domain: error!.localizedDescription, code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    guard let snap = snapShot else {
                        let error = NSError(domain: "No data was received", code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    print("finish loading years")
                    var years: [String] = []
                    snap.documents.forEach({ years.append($0.documentID) })
                    promise(.success(years))
                }
        }
    }

    public func getMonthsWithTransactions(year: String) -> Future<[String], Error> {
        return Future { promise in
            guard let userID = self.getUserID() else {
                let error = NSError(domain: "No userID", code: 1, userInfo: nil)
                promise(.failure(error))
                return
            }
            self.db
                .collection(AppConstants.kUsers)
                .document(userID)
                .collection(AppConstants.kYears)
                .document(year)
                .collection(AppConstants.kMonths)
                .getDocuments { snapShot, error in
                    if error != nil {
                        let error = NSError(domain: error!.localizedDescription, code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    guard let snap = snapShot else {
                        let error = NSError(domain: "No data was received", code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    print("finish loading months")
                    var months: [String] = []
                    snap.documents.forEach({ months.append($0.documentID) })
                    promise(.success(months))
                }
        }
    }

}
