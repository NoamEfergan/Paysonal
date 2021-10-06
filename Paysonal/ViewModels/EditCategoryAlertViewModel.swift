//
//  EditCategoryAlertViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 05/10/2021.
//

import UIKit

protocol EditCategoryAlertService: AnyObject {
    func didSelectCategory(title: String)
    func showError(msg: String)
}

class EditCategoryAlertViewModel {

    // MARK: - Variables

    private var categoryToBeEdited: Category?
    private var newName: String?
    private var newColor: String?
    private var newCategory: Category?
    private var isEditingName: Bool = false
    private var isEditingColor: Bool = false
    private var service: EditCategoryAlertService!

    // MARK: - Init method
    init(delegate: EditCategoryAlertService) {
        self.service = delegate
    }

    // MARK: - Public methods

    public func getCategories() -> [UIMenuElement] {
        var newItems:[UIMenuElement] = []
        let allCategories = UserPreferences.shared?.getCategories() ?? []
        for category in allCategories {
            let menuItem = UIAction(title: category.name, handler: { _ in
                self.didSelectCategory(category)
            })
            newItems.append(menuItem)
        }
        return newItems
    }

    public func getCategoryToBeEdited() -> Category? {
        return self.categoryToBeEdited
    }

    public func setNewName(_ name: String) {
        self.newName = name
        self.isEditingName = true
    }

    public func setColor(_ color: String) {
        self.newColor = color
        self.isEditingColor = true
    }

    public func didTapApplyEdit() -> Bool {
        if isEditingName && newName.isEmptyOrNil() {
            service.showError(msg: AppStrings.newCategoryAlertBody)
            return false
        }
        if isEditingColor && newColor.isEmptyOrNil() {
            service.showError(msg: AppStrings.colorError)
            return false
        }
        if categoryToBeEdited == nil {
            service.showError(msg: AppStrings.categoryError)
            return false
        }
        guard let userPreferences = UserPreferences.shared,
              userPreferences.editCategory(categoryToBeEdited: categoryToBeEdited!, newName: newName, newColor: newColor)
        else {
            return false
        }
        return true
    }

    // MARK: - private methods

    private func didSelectCategory(_ cat: Category) {
        self.categoryToBeEdited = cat
        self.service.didSelectCategory(title: cat.name)
    }
}
