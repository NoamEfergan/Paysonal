//
//  SourceOfIncome.swift
//  Paysonal
//
//  Created by Noam Efergan on 14/10/2021.
//

import Foundation

public class SourceOfIncome {

    var amount: Double
    var name: String
    var date: String

    init(name: String, date: String, amount: Double ) {
        self.name = name
        self.date = date
        self.amount = amount
    }
}
