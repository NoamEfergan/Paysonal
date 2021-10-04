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
    public func removeTransaction(year: String, month: String, txDate: String) {
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year)
            .collection(AppConstants.kMonths)
            .document(month)
            .collection(AppConstants.kTransactions)
            .document(txDate)
            .delete()
    }

    /// Fetch transactions for the current month from Firestory
    public func fetchTransactions(
        year: String = Date().getCurrentYear(),
        month: String = Date().getCurrentMonth()
    ) -> Future<[Entry],Error> {
        return Future { [self] promise in
            guard let userID = UserPreferences.shared?.getUserID() else {
                let error = NSError(domain: "No user ID", code: 1, userInfo: nil)
                promise(.failure(error))
                return
            }
            db.collection(AppConstants.kUsers)
                .document(userID)
                .collection(AppConstants.kYears)
                .document(year)
                .collection(AppConstants.kMonths)
                .document(month)
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
               let name = document.data()[AppConstants.kCategory] as? String,
               let colorHex = document.data()[AppConstants.kColor] as? String {
                let category = Category(name: name, colorHex: colorHex)
                let transaction = Transaction(amount: amount, date: document.documentID, category: category)
                let _ = UserPreferences.shared?.addNewCategory(newCategory: category)
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
        if self.dataEntries.contains(where: {$0.category.name == tx.category.name}) {
            self.dataEntries.first(where: {$0.category.name == tx.category.name})?.addTransaction(tx)
            return
        }
        // If not, create a new entry and add that
        let newEntry = Entry(category: tx.category)
        newEntry.addTransaction(tx)
        dataEntries.append(newEntry)
    }

//    private func addTxToFirestore(_ tx: Transaction) {
//        guard let month = Date().getMonthFromString(tx.date),
//              let year = Date().getYearFromString(tx.date) else { return }
//        db.collection(AppConstants.kUsers)
//            .document(UserPreferences.shared!.getUserID()!)
//            .collection(AppConstants.kYears)
//            .document(year)
//            .collection(AppConstants.kMonths)
//            .document(month).getDocument { [weak self] snapShot, error in
//                guard let self = self else {
//                    fatalError("Failed to capture self,add TX flow")
//                }
//                if error != nil {
//                    return
//                }
//                if snapShot!.exists {
//                    self.setTxInExistingMonth(tx,year: year, month: month)
//                } else {
//                    self.setTxInNewMonth(tx, year: year, month: month)
//                }
//            }
//    }

    private func setTxInExistingYear(_ tx: Transaction) {
        guard let month = Date().getMonthFromString(tx.date),
              let year = Date().getYearFromString(tx.date) else { return }
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year)
            .collection(AppConstants.kMonths)
            .document(month).getDocument { [weak self] snapShot, error in
                guard let self = self else {
                    fatalError("Failed to capture self,add TX flow")
                }
                if error != nil {
                    return
                }
                if snapShot!.exists {
                    self.setTxInExistingMonth(tx,year: year, month: month)
                } else {
                    self.setTxInNewMonth(tx, year: year, month: month)
                }
            }
    }

    private func setTxInNewYear(_ tx: Transaction) {
        guard let year = Date().getYearFromString(tx.date) else { return }
        self.db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year)
        // Have to a field to the document or it doesn't "exist"
            .setData(["created": FieldValue.serverTimestamp()]) { _ in
                // Add tx to the year
                self.setTxInExistingYear(tx)
            }
    }

    private func addTxToFirestore(_ tx: Transaction) {
        guard let year = Date().getYearFromString(tx.date) else { return }
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year).getDocument(completion: {[weak self] snapShot, error in
                guard let self = self, error == nil else {
                    fatalError("Failed to capture self,add TX flow")
                }
                if snapShot!.exists {
                    self.setTxInExistingYear(tx)
                } else {
                    self.setTxInNewYear(tx)
                }
            })
    }

    private func setTxInExistingMonth(_ tx: Transaction, year: String, month: String) {
        db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year)
            .collection(AppConstants.kMonths)
            .document(month)
            .collection(AppConstants.kTransactions)
            .document(tx.date)
            .setData([
                AppConstants.kAmount: tx.amount!,
                AppConstants.kCategory: tx.category.name!,
                AppConstants.kColor: tx.category.colorHex!
            ], merge: true)
    }

    private func setTxInNewMonth(_ tx: Transaction,year: String, month: String) {
        // Create month document
        self.db.collection(AppConstants.kUsers)
            .document(UserPreferences.shared!.getUserID()!)
            .collection(AppConstants.kYears)
            .document(year)
            .collection(AppConstants.kMonths)
            .document(month)
        // Have to a field to the document or it doesn't "exist"
            .setData(["created": FieldValue.serverTimestamp()]) { _ in
                // Add tx to the month
                self.setTxInExistingMonth(tx, year: year, month: month)
            }
    }
}
