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
    var category: String!
    var color: UIColor = UIColor.random

    // MARK: - init method
    init(category: String) {
        self.category = category
    }

    // MARK: - Public methods

    public func addTransaction(_ tx: Transaction) {
        transactions.append(tx)
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
