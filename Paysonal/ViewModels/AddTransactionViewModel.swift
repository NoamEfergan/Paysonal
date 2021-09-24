//
//  AddTransactionViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 24/09/2021.
//

import UIKit

// MARK: - Protocol methods

protocol AddTransactionService: AnyObject {
    func askForNewCategory()
    func showError()
    func updateMenu(title: String)
}

public class AddTransactionViewModel {

    // MARK: - Variables

    private var category: String?
    private var amount: Double?
    private var date: String?

    private var service:  AddTransactionService?

    // MARK: - Init methods
    init(delegate: AddTransactionService) {
        self.service = delegate
    }

    // MARK: - Public methods

    public func getOptions() -> [UIMenuElement] {
        var newItems:[UIMenuElement] = []
        let allCategories = UserPreferences.shared?.getAllCategories() ?? []
        for category in allCategories {
            let menuItem = UIAction(title: category, handler: { _ in
                self.category = category
            })
            newItems.append(menuItem)
        }

        let otherCategory = UIAction(title: "Other", handler: {_ in
            self.service?.askForNewCategory()
        })
        newItems.append(otherCategory)
        return newItems
    }

    public func setNewCategory(newCategory: String) {
        guard let added = UserPreferences.shared?.addNewCategory(newCategory: newCategory),
        added else {
            service?.showError()
            return
        }
        self.category = newCategory
        self.service?.updateMenu(title: newCategory)
    }
}
