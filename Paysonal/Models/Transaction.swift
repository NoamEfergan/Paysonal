//
//  Transaction.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

public class Transaction: Equatable {

    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return (lhs.category == rhs.category && lhs.amount == rhs.amount && lhs.date == rhs.date )
    }


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
