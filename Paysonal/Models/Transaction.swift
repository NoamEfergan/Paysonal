//
//  Transaction.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

public class Transaction {

    // MARK: - Variables

    let amount: Double!
    let date: String!
    let category: Category!

    // MARK: - init method
    init(amount: Double, date: String, category: Category) {
        self.amount = amount
        self.date = date
        self.category = category
    }

}
