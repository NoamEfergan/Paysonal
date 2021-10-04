//
//  SettingsViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 04/10/2021.
//

import UIKit

protocol SettingsService: AnyObject {
    func showError(msg: String)
    func didChangeName()
}

class SettingsViewModel {

    // MARK: - Variables

    private var service: SettingsService!

    // MARK: - Init method
    init(delegate: SettingsService) {
        self.service = delegate
    }

    // MARK: - Public methods

    public func getNewNameAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: AppStrings.alertTitle,
            message: AppStrings.nameChange,
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.addDoneButtonOnKeyboard()
        }
        alert.addAction(UIAlertAction(title: AppStrings.cancel, style: .destructive, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: AppStrings.confirm, style: .default, handler: { _ in
            if let textField = alert.textFields?.first,
               !textField.text.isEmptyOrNil() {
                UserPreferences.shared?.setUsername(with: textField.text!)
                self.service.didChangeName()
                alert.dismiss(animated: true, completion: nil)
            } else {
                self.service.showError(msg: AppStrings.somethingWentWrong)
            }
        }))
        return alert
    }
}
