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
    func showError(msg: String)
    func updateMenu(title: String)
    func updateCategoryButton(withTitle: String)
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

    // MARK: - Private methods

    private func onSelectCategory(withTitle category: String) {
        self.category = category
        self.service?.updateCategoryButton(withTitle: category)
    }

    // MARK: - Public methods

    public func getOptions() -> [UIMenuElement] {
        var newItems:[UIMenuElement] = []
        let allCategories = UserPreferences.shared?.getCategories() ?? []
        for category in allCategories {
            let menuItem = UIAction(title: category, handler: { _ in
                self.onSelectCategory(withTitle: category)
            })
            newItems.append(menuItem)
        }

        let otherCategory = UIAction(title: AppStrings.newCategory, handler: {_ in
            self.service?.askForNewCategory()
        })
        newItems.append(otherCategory)
        return newItems
    }

    public func setNewCategory(newCategory: String) {
        guard let added = UserPreferences.shared?.addNewCategory(newCategory: newCategory),
        added else {
            service?.showError(msg: AppStrings.categoryExists)
            return
        }
        self.category = newCategory
        self.service?.updateMenu(title: newCategory)
    }

    public func setCategory(with category: String) {
        self.category = category
    }

    public func setAmount(with amount: Double) {
        self.amount = amount
    }

    public func setDate(with date: String) {
        self.date = date
    }

    public func onTapApply() -> Bool{
        if category == nil || category == "" { self.service?.showError(msg: AppStrings.categoryError); return false }
        if amount == nil { self.service?.showError(msg: AppStrings.amountError); return false}
        if date == nil || date == "" { self.service?.showError(msg: AppStrings.dateError); return false}
        let tx = Transaction(amount: amount!, date: date!, category: category!)
        UserTransactionsManager.shared?.addTransaction(tx)
        return true
    }
}
