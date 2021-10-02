//
//  UIViewExtension.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit
import JGProgressHUD

extension UIView {

    func showLoader(message: String? = nil) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD(style: .dark)
            self.endEditing(false)
            hud.textLabel.text = message
            hud.show(in: self)
        }
    }

    func hideLoader() {
        for loader in JGProgressHUD.allProgressHUDs(in: self) {
            DispatchQueue.main.async {
                loader.dismiss()
            }
        }
    }

    func addDropShadow() {
        self.backgroundColor = .secondarySystemBackground
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = AppConstants.cornerRadTabBar
        self.layer.shadowOpacity = Float(AppConstants.shadowOpacity)
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = AppConstants.shadowRad
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.clipsToBounds = false
    }
}
