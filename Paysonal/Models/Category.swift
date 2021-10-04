//
//  Category.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import Foundation

public class Category: Equatable {

    public static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name && lhs.colorHex == rhs.colorHex
    }


    // MARK: - Variables

    let name: String!
    let colorHex: String!

    // MARK: - init methods
    init(name: String, colorHex: String) {
        self.name = name
        self.colorHex = colorHex
    }
}
