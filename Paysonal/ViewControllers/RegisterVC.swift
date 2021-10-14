//
//  RegisterVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit

class RegisterVC: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var containerStackView: UIStackView!

    // MARK: - Variables

    private var viewModel: RegisterViewModel?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustTitles()
        initButton()
        animateViewForKeyboard()
        self.view.backgroundColor = .secondarySystemBackground
        viewModel = RegisterViewModel(delegate: self)
    }

    // MARK: - Private methods

    private func adjustTitles() {
        self.nameTextfield.placeholder = AppStrings.nameTitle
        self.emailTextfield.placeholder = AppStrings.emailTitle
        self.passwordTextfield.placeholder = AppStrings.passwordTitle
        self.registerButton.setTitle(AppStrings.registerTitle, for: .normal)
        self.emailErrorLabel.text = AppStrings.emailError
        self.passwordErrorLabel.text = AppStrings.passwordError

        self.emailTextfield.addDoneButtonOnKeyboard()
        self.passwordTextfield.addDoneButtonOnKeyboard()
        self.nameTextfield.addDoneButtonOnKeyboard()
    }

    private func initButton() {
        self.registerButton.isHighlighted = true
        self.registerButton.isUserInteractionEnabled = false
    }

    private func handleRegisterButton() {
        guard let emailText = emailTextfield.text,
              let passwordText = passwordTextfield.text,
              let vm = self.viewModel,
              vm.validateEmail(email: emailText),
              vm.validatePassword(password: passwordText) else {
                  self.registerButton.isHighlighted = true
                  self.registerButton.isUserInteractionEnabled = false
                  return
              }
        self.registerButton.isHighlighted = false
        self.registerButton.isUserInteractionEnabled = true
    }

    // MARK: - Textfield methods

    @IBAction func editingEndEmail(_ sender: UITextField) {
        if let text = sender.text,
        let validEmail = viewModel?.validateEmail(email: text) {
            self.emailErrorLabel.isHidden = validEmail
        }
        handleRegisterButton()
    }

    @IBAction func editngEndPassword(_ sender: UITextField) {
        if let text = sender.text,
        let validPassword = viewModel?.validatePassword(password: text) {
            self.passwordErrorLabel.isHidden = validPassword
        }
        handleRegisterButton()
    }

    // MARK: - Actions
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.viewModel?.performRegister(
            withEmail: emailTextfield.text!,
            password: passwordTextfield.text!,
            name: nameTextfield.text)
    }

    // MARK: - Keyboard Selector Methods

    private func animateViewForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - AppConstants.KeyboardToolbar
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

    // MARK: - Protocol methods

extension RegisterVC: RegisterService {
    
    func showErrorRegistering(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func onSuccessRegister() {
        performSegue(withIdentifier: AppStrings.showDashboard , sender: self)
    }

    func showLoader() {
        self.view.showLoader(message: nil)
    }

    func hideLoader() {
        self.view.hideLoader()
    }
}
