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

    private var category: Category?
    private var amount: Double?
    private var date: String?

    private var service:  AddTransactionService?

    // MARK: - Init methods
    init(delegate: AddTransactionService) {
        self.service = delegate
        addSubscriber()
    }

    deinit {
        removeSubscriber()
    }

    // MARK: - Private methods

    private func removeSubscriber() {
        NotificationCenter.default.removeObserver(
            self,
            name: .newCategory,
            object: nil
        )
    }

    private func addSubscriber() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newCategoryReceived),
            name: .newCategory,
            object: nil
        )
    }

    @objc func newCategoryReceived(_ notification: NSNotification) {
        if let receivedCategory = notification.userInfo?[AppConstants.kCategory] as? Category {
            self.setNewCategory(newCategory: receivedCategory)
        }
    }

    private func onSelectCategory(withTitle category: String) {
        guard let selectedCategory = UserPreferences.shared?.getCategories()
                .first(where: {$0.name.lowercased() == category.lowercased()})
        else {
            self.service?.showError(msg:AppStrings.somethingWentWrong)
            return
        }
        self.category = selectedCategory
        self.service?.updateCategoryButton(withTitle: selectedCategory.name)
    }

    // MARK: - Public methods

    public func getOptions() -> [UIMenuElement] {
        var newItems:[UIMenuElement] = []
        let allCategories = UserPreferences.shared?.getCategories() ?? []
        for category in allCategories {
            let menuItem = UIAction(title: category.name, handler: { _ in
                self.onSelectCategory(withTitle: category.name)
            })
            newItems.append(menuItem)
        }

        let otherCategory = UIAction(title: AppStrings.newCategory, handler: {_ in
            self.service?.askForNewCategory()
        })
        newItems.append(otherCategory)
        return newItems
    }

    public func setNewCategory(newCategory: Category) {
        guard let added = UserPreferences.shared?.addNewCategory(newCategory: newCategory),
        added else {
            service?.showError(msg: AppStrings.categoryExists)
            return
        }
        self.category = newCategory
        self.service?.updateMenu(title: newCategory.name)
    }

    public func setCategory(with category: Category) {
        self.category = category
    }

    public func setAmount(with amount: Double) {
        self.amount = amount
    }

    public func setDate(with date: String) {
        self.date = date
    }

    public func onTapApply() -> Bool{
        if category == nil || category?.name == "" { self.service?.showError(msg: AppStrings.categoryError); return false }
        if amount == nil { self.service?.showError(msg: AppStrings.amountError); return false}
        if date.isEmptyOrNil() { self.service?.showError(msg: AppStrings.dateError); return false}
        let tx = Transaction(amount: amount!, date: date!, category: category!)
        UserTransactionsManager.shared?.addTransaction(tx)
        return true
    }
}
