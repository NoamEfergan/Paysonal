//
//  NewCategoryViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import Foundation

protocol NewCategoryService: AnyObject {
    func showError(msg: String)
}

public class NewCategoryViewModel {

    // MARK: - Variables

    private var service: NewCategoryService!

    private var name: String?
    private var colorHex: String?

    // MARK: - init methods
    init(delegate: NewCategoryService) {
        self.service = delegate
    }

    // MARK: - Public methods

    public func setName(with name: String) {
        self.name = name
    }

    public func setColor(with color: String) {
        self.colorHex = color
    }

    public func onTapApply() -> Bool {
        if name.isEmptyOrNil() { self.service.showError(msg: AppStrings.newCategoryAlertTitle); return false}
        if colorHex.isEmptyOrNil() { self.service.showError(msg:AppStrings.colorError); return false}
        let category = Category(name: name!, colorHex: colorHex!)
        NotificationCenter.default.post(name: .newCategory, object: nil,userInfo: [AppConstants.kCategory: category])
        return true
    }

}
