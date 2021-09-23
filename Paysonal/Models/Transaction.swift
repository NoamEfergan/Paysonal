//
//  Transaction.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

class Transaction {

    // MARK: - Variables

    let amount: String!
    let date: String!

    // MARK: - init method
    init(amount: String, date: String) {
        self.amount = amount
        self.date = date
    }

}
