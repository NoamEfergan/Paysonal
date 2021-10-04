//
//  Entry.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation
import UIKit

public class Entry {

    // MARK: - Variables

    private var transactions: [Transaction] = []
    var category: Category!

    // MARK: - init method
    init(category: Category) {
        self.category = category
    }

    // MARK: - Public methods

    public func addTransaction(_ tx: Transaction) {
        guard !transactions.isEmpty else {
            transactions.append(tx)
            NotificationCenter.default.post(name: .newTransaction, object: nil)
            return
        }
           if let firstTxDateString = transactions.first?.date,
           let entryYear = Date().getYearFromString(firstTxDateString),
           let entryMonth = Date().getMonthFromString(firstTxDateString),
           let newTxYear = Date().getYearFromString(tx.date),
           let newTxMonth = Date().getMonthFromString(tx.date),
            entryYear == newTxYear, entryMonth == newTxMonth {
               transactions.append(tx)
               NotificationCenter.default.post(name: .newTransaction, object: nil)
        }
    }

    public func removeTransaction(tx: Transaction ) {
        self.transactions.removeAll(where: {$0 == tx})
    }

    public func addMultipleTransactions( _ txs: [Transaction]) {
        transactions += txs
    }

    public func getTransactions() -> [Transaction] {
        return self.transactions
    }

    /// A method to get the value of all the transactions in the entry
    /// - Returns: A double value of all of the transactions
    public func getTotalValue() -> Double {
        var totalValue  = 0.0
        for transaction in transactions {
            if let value = transaction.amount {
                totalValue = totalValue + value
            }
        }
        return totalValue
    }
}
