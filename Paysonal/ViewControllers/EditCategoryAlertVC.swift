//
//  EditCategoryAlertVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 05/10/2021.
//

import UIKit

class EditCategoryAlertVC: UIViewController {

    // MARK: - Variables

    private var viewModel: EditCategoryAlertViewModel!

    // MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    @IBOutlet weak var editDeleteSelecter: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var editStackView: UIStackView!


    // MARK: - Lifecycle method

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditCategoryAlertViewModel(delegate: self)
        initUI()
    }

    // MARK: - Actions
    
    @IBAction func didChangeEditOrDelete(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            editStackView.isHidden = true
        } else {
            editStackView.isHidden = false
        }
    }
    @IBAction func onTapApply(_ sender: UIButton) {
        if editDeleteSelecter.selectedSegmentIndex == 1 {
            showAlertBeforeDeleting()
        } else {
            guard viewModel.didTapApplyEdit() else { self.showError(msg: AppStrings.somethingWentWrong); return }
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapChooseColor(_ sender: UIButton) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.supportsAlpha = false
        colorPickerVC.modalPresentationStyle = .popover
        colorPickerVC.modalTransitionStyle = .crossDissolve
        present(colorPickerVC, animated: true)

        let popOverVC = colorPickerVC.popoverPresentationController
        popOverVC?.sourceView = sender
        colorPickerVC.delegate = self
    }

    @IBAction func didSelectName(_ sender: UITextField) {
        if let text = sender.text {
            viewModel.setNewName(text)
        }
    }
    //MARK: - Private methods

    private func initUI() {
        self.containerView.layer.cornerRadius = AppConstants.cornerRad
        self.view.backgroundColor = .clear
        self.containerView.addDropShadow()
        self.editDeleteSelecter.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor(named: AppConstants.textColor)!]
            , for: .selected
        )
        self.chooseCategoryButton.menu = UIMenu.init(
            title: AppStrings.chooseCategory,
            options: .singleSelection,
            children: viewModel.getCategories()
        )
    }

    private func showAlertBeforeDeleting() {
        let action = UIAlertAction(title: AppStrings.delete, style: .default) { _ in
            guard let cat = self.viewModel.getCategoryToBeEdited() else {
                self.showErrorAlert(msg: AppStrings.emptyCatErr)
                return
            }
            UserPreferences.shared?.removeCategory(cat)
            self.dismiss(animated: true, completion: nil)
        }
        self.showActionAlert(msg: AppStrings.verifyDeleteCat, action: action)
    }

}

// MARK: - Color picker methods

extension EditCategoryAlertVC: UIColorPickerViewControllerDelegate {

    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.viewModel.setColor(viewController.selectedColor.toHex())
    }

}

    // MARK: - Protocol methods

extension EditCategoryAlertVC: EditCategoryAlertService {
    func showError(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func didSelectCategory(title: String) {
        self.chooseCategoryButton.setTitle(title, for: .normal)
    }


}
