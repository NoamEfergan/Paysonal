//
//  UserTransactionsManager.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit
import FirebaseFirestore
import Combine

public class UserTransactionsManager {

    // MARK: - Variables

    private(set) static var shared: UserTransactionsManager?
    private let db = Firestore.firestore()
    private var dataEntries: [Entry] = []

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserTransactionsManager() }
    }

    init() {
    }

    // MARK: - Public methods

    /// Fetch transactions for the current month from Firestory
    public func getTransactionsForCurrentMonth() -> Future<[Entry],Error> {
        return Future { [self] promise in
            guard let userID = UserPreferences.shared?.getUserID() else {
                let error = NSError(domain: "No user ID", code: 1, userInfo: nil)
                promise(.failure(error))
                return
            }
            db.collection(AppConstants.kUsers)
                .document(userID)
                .collection(AppConstants.kMonths)
                .document(getCurrentMonth())
                .collection(AppConstants.kTransactions)
                .getDocuments { [weak self] snapShot, error in
                    guard let self = self else {
                        fatalError("Failed to capture self, get transactions for current month flow")
                    }
                    if error != nil {
                        self.dataEntries = []
                        let error = NSError(domain: error!.localizedDescription, code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    guard let snap = snapShot else {
                        self.dataEntries = []
                        let error = NSError(domain: "No data was received", code: 1, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    promise(.success(self.handleDocuments(documents: snap.documents)))
                }
        }
    }

    // MARK: - Private methods

    /// Takes in the documents from Firestore and converts them to entries
    /// - Parameter documents: Firestore Document
    private func handleDocuments(documents: [QueryDocumentSnapshot] ) -> [Entry] {
        self.dataEntries = []
        for document in documents {
            if let amount = document.data()[AppConstants.kAmount] as? Double,
               let category = document.data()[AppConstants.kCategory] as? String {
                let transaction = Transaction(amount: amount, date: document.documentID, category: category)
                convertTransactionToEntry(transaction)
            }
        }
        return dataEntries
    }

    /// Converts a transaction into an entry, and adds that entry to the data entries array
    /// - Parameter tx: Transaction object
    private func convertTransactionToEntry(_ tx: Transaction) {
        // Check if the category already exists in the data entries array
        if self.dataEntries.contains(where: {$0.category == tx.category}) {
            self.dataEntries.first(where: {$0.category == tx.category})?.addTransaction(tx)
            return
        }
        // If not, create a new entry and add that
        let newEntry = Entry(category: tx.category)
        newEntry.addTransaction(tx)
        dataEntries.append(newEntry)
    }

    private func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }

    public func getEntries() -> [Entry] {
        return dataEntries
    }
}
