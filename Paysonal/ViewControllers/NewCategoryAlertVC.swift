//
//  NewCategoryAlertVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import UIKit

class NewCategoryAlertVC: UIViewController {

    // MARK: - outlets

    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var chooseColorButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        addDropShadow()
        self.categoryNameTextField.addDoneButtonOnKeyboard()
    }

    // MARK: - Actions

    @IBAction func didFinishEditingCategory(_ sender: UITextField) {
    }

    @IBAction func didTapColor(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.supportsAlpha = false
        colorPickerVC.modalPresentationStyle = .popover
        colorPickerVC.modalTransitionStyle = .crossDissolve
        present(colorPickerVC, animated: true)

        let popOverVC = colorPickerVC.popoverPresentationController
        popOverVC?.sourceView = sender
        colorPickerVC.delegate = self
    }
    @IBAction func didTapAdd(_ sender: UIButton) {
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
    }
    // MARK: - Private methods

    private func addDropShadow() {
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.cornerRadius = AppConstants.cornerRadTabBar
        containerView.layer.shadowOpacity = Float(AppConstants.shadowOpacity)
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = AppConstants.shadowRad
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.borderWidth = 0
        containerView.clipsToBounds = false
    }
}

// MARK: - Color picker methods

extension NewCategoryAlertVC: UIColorPickerViewControllerDelegate {

}
