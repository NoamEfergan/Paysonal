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
}
