//
//  UIViewControllerExtension.swift
//  Paysonal
//
//  Created by Noam Efergan on 28/09/2021.
//

import UIKit

extension UIViewController {

    func showPopupAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

    func showErrorAlert(msg: String?) {
        let alert = UIAlertController(title: AppStrings.errorTitle, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

    func showActionAlert(msg: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: AppStrings.alertTitle, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
