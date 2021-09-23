//
//  Transaction.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

class Transaction {

    // MARK: - Variables

    let amount: Double!
    let date: String!
    let category: String!

    // MARK: - init method
    init(amount: Double, date: String, category: String) {
        self.amount = amount
        self.date = date
        self.category = category
    }

}
