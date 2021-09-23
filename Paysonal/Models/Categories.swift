//
//  Categories.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import Foundation

struct Categories {
    enum defaultCategories: String, CaseIterable {
        case Housing
        case Car
        case Amenities
    }
    public static var userCategories: [String] = []
}
