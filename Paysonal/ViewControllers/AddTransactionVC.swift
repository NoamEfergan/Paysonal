//
//  AddTransactionVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 24/09/2021.
//

import UIKit

class AddTransactionVC: UIViewController {

    // MARK: - outlets

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadeBackground: UIView!

    // MARK: - Variables

    private var viewModel: AddTransactionViewModel!

    // MARK: -Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTransactionViewModel(delegate: self)
        self.amountTextField.delegate = self
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.amountTextField.addDoneButtonOnKeyboard()
        self.shadeBackground.backgroundColor = .black.withAlphaComponent(AppConstants.shadowOpacity)
        self.containerView.layer.cornerRadius = AppConstants.cornerRad
        self.containerView.backgroundColor = .secondarySystemBackground
        self.categoryButton.menu = UIMenu.init(
            title: AppStrings.chooseCategory,
            options: .displayInline,
            children: viewModel.getOptions()
        )
    }

    // MARK: - Actions

    @IBAction func didPickDate(_ sender: UIDatePicker) {
        viewModel.setDate(with: sender.date.getStringFromDate())
    }

    @IBAction func didFinishAddingAmount(_ sender: UITextField) {
        if let text = sender.text,
           let amountDouble = Double(text) {
            viewModel.setAmount(with: amountDouble)
        }
    }

    @IBAction func applyTapped(_ sender: Any) {
        guard viewModel.onTapApply() else { return }
        self.dismiss(animated: true)
    }

    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

    // MARK: - Textfield methods
extension AddTransactionVC: UITextFieldDelegate {

    // Allow only decimal numbers to be entered
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
    -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.firstIndex(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }

        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}

// MARK: - Protocol methods

extension AddTransactionVC: AddTransactionService {

    func askForNewCategory() {
        let alert = UIAlertController(title: AppStrings.newCategoryAlertTitle, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = AppStrings.newCategoryAlertBody
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let value = alert.textFields?.first?.text {
                self.viewModel.setNewCategory(newCategory: value)
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

    func showError(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func updateMenu(title: String) {
        self.categoryButton.menu = UIMenu.init(
            title: AppStrings.chooseCategory,
            options: .displayInline,
            children: viewModel.getOptions()
        )
        self.categoryButton.setTitle(title, for: .normal)
    }

    func updateCategoryButton(withTitle: String) {
        self.categoryButton.setTitle(withTitle, for: .normal)
    }
}
