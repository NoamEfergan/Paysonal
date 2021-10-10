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
    @IBOutlet weak var transactionOrFundsSelector: UISegmentedControl!
    @IBOutlet weak var AddTransactionView: UIView!
    @IBOutlet weak var addFundsView: UIView!
    @IBOutlet weak var addFundsAmountTextField: UITextField!
    @IBOutlet weak var addFundsSourceButton: UIButton!
    // MARK: - Variables

    private var viewModel: AddTransactionViewModel!

    // MARK: -Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTransactionViewModel(delegate: self)
        // Set the initial date as the current day
        viewModel.setDate(with: Date().getStringFromDate())
        self.amountTextField.delegate = self
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.amountTextField.addDoneButtonOnKeyboard()
        self.transactionOrFundsSelector.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor(named: AppConstants.textColor)!]
            , for: .selected
        )
        self.shadeBackground.backgroundColor = .black.withAlphaComponent(AppConstants.shadowOpacity)
        self.containerView.layer.cornerRadius = AppConstants.cornerRad
        self.containerView.backgroundColor = .secondarySystemBackground
        self.categoryButton.menu = UIMenu.init(
            title: AppStrings.chooseCategory,
            options: .singleSelection,
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
        if viewModel.onTapApply() {
            self.dismiss(animated: true)
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func changeTransactionOrFunds(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            AddTransactionView.isHidden = false
            addFundsView.isHidden = true
        } else {
            AddTransactionView.isHidden = true
            addFundsView.isHidden = false
        }
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
        let storyboard = UIStoryboard(name: NibNames.categoryAlert, bundle: .main)
        let popupVC = storyboard.instantiateViewController(withIdentifier: NibNames.categoryAlert + "VC")
        as! NewCategoryAlertVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }

    func showError(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func updateMenu(title: String) {
        self.categoryButton.menu = UIMenu.init(
            title: AppStrings.chooseCategory,
            options: .singleSelection,
            children: viewModel.getOptions()
        )
        self.categoryButton.setTitle(title, for: .normal)
    }

    func updateCategoryButton(withTitle: String) {
        self.categoryButton.setTitle(withTitle, for: .normal)
    }
}
