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
    private var dataEntries: [Entry] = [] {
        didSet {
            NotificationCenter.default.post(name: .newEntry, object: nil)
        }
    }

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserTransactionsManager() }
    }

    init() {
    }

    // MARK: - Public methods

    public func addTransaction(_ tx: Transaction) {
        self.convertTransactionToEntry(tx)
        self.addTxToFirestore(tx)
    }

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
                .document(Date().getCurrentMonth())
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

    public func getEntries() -> [Entry] {
        return dataEntries
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
        // If the array is empty, check if the tx month is the same as the current month
        if self.dataEntries.isEmpty {
            guard Date().getMonthFromString(tx.date) == Date().getCurrentMonth() else {
                return
            }
            addTxToEntries(tx)
            return
        }
        // Check that the month of the entry is the same as the month of the array
        guard let entry = self.dataEntries.first,
              let firstTx = entry.getTransactions().first,
              Date().getMonthFromString(firstTx.date) == Date().getMonthFromString(tx.date) else { return }
        addTxToEntries(tx)
    }

    /// Take the transaction and add it to the active entries array
    /// - Parameter tx: Transaction
    private func addTxToEntries(_ tx: Transaction) {
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

    private func addTxToFirestore(_ tx: Transaction) {
        guard let month = Date().getMonthFromString(tx.date) else { return }
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kMonths)
            .document(month).getDocument { [weak self] snapShot, error in
                guard let self = self else {
                    fatalError("Failed to capture self,add TX flow")
                }
                if error != nil {
                    return
                }
                if snapShot!.exists {
                    self.setTxInExistingMonth(tx, month: month)
                } else {
                    self.setTxInNewMonth(tx, month: month)
                }
            }
    }

    private func setTxInExistingMonth(_ tx: Transaction, month: String) {
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kMonths)
            .document(month)
            .collection(AppConstants.kTransactions)
            .document(tx.date)
            .setData([AppConstants.kAmount: tx.amount!, AppConstants.kCategory: tx.category!])
    }

    private func setTxInNewMonth(_ tx: Transaction, month: String) {
        // Create month document
        self.db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kMonths)
            .document(month)
            .setData([:])
        // Add tx to the month
        self.setTxInExistingMonth(tx, month: month)
    }
}
