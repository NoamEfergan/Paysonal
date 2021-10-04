//
//  LoginVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit

class LoginVC: UIViewController, UIPopoverPresentationControllerDelegate {

    // MARK: - Outlets

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var anotherAccountButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    // MARK: - Variables

    private var viewModel: LoginViewModel?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginViewModel(delegate: self)
        self.view.backgroundColor = .secondarySystemBackground
        self.welcomeLabel.text = viewModel?.getWelcomeTitle()
        self.emailTextfield.addDoneButtonOnKeyboard()
        self.passwordTextField.addDoneButtonOnKeyboard()
        handleRegisteredUser()
    }

    func adaptivePresentationStyle(
        for _: UIPresentationController, traitCollection _: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: - Private methods

    func handleRegisteredUser() {
        guard let isRegistered = UserPreferences.shared?.isUserRegistered(), isRegistered else {
            self.emailTextfield.isHidden = false
            self.emailLabel.isHidden = true
            self.anotherAccountButton.isHidden = true
            self.registerButton.isHidden = false
            self.resetPasswordButton.isHidden = true
            return
        }
        self.emailTextfield.isHidden = true
        self.emailTextfield.text = UserPreferences.shared?.getUserEmail()
        self.emailLabel.isHidden = false
        self.emailLabel.text = viewModel?.getEmailTitle()
        self.anotherAccountButton.isHidden = false
        self.registerButton.isHidden = true
        self.resetPasswordButton.isHidden = false
    }

    // MARK: - Actions

    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextfield.text,
              let password = passwordTextField.text,
        !email.isEmpty, !password.isEmpty else {
                  self.passwordErrorLabel.isHidden = false
                  self.passwordErrorLabel.text = AppStrings.errorLogin
                  return
              }
        self.passwordErrorLabel.isHidden = true
        viewModel?.performLogIn(email: email, password: password)
    }

    @IBAction func resetPasswordTapped(_ sender: Any) {
        guard let email = emailTextfield.text, !email.isEmpty else {
            self.showErrorAlert(msg: AppStrings.emailError)
            return
        }
        self.showActionAlert(msg: AppStrings.resetPasswordAlert, action: UIAlertAction(
            title: AppStrings.reset, style: .default, handler: { _ in
                UserPreferences.shared?.resetUser()
                self.viewModel?.performResetPassword(email: email)
            }))
    }

    @IBAction func registerTapped(_ sender: Any) {
        navigateToRegister()
    }

    @IBAction func anotherAccountTapped(_ sender: Any) {
        UserPreferences.shared?.resetUser()
        self.emailTextfield.isHidden = false
        self.emailTextfield.text = nil
        self.emailLabel.isHidden = true
        self.anotherAccountButton.isHidden = true
        self.registerButton.isHidden = false
        self.resetPasswordButton.isHidden = true
        self.welcomeLabel.text = viewModel?.getWelcomeTitle()
    }

    // MARK: - Private methods

    private func navigateToRegister() {
        let storyboard = UIStoryboard(name: NibNames.register, bundle: .main)
        let vc =  storyboard.instantiateViewController(withIdentifier: NibNames.register + "VC") as! RegisterVC
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

    // MARK: - Protocol methods

extension LoginVC: LoginService {

    func onSuccessReset() {
        self.showPopupAlert(title: AppStrings.resetAlertTitle, msg: AppStrings.resetAlertMsg)
    }


    func showLoader() {
        self.view.showLoader(message: nil)
    }
    
    func hideLoader() {
        self.view.hideLoader()
    }

    func onSuccessLogin() {
        performSegue(withIdentifier: AppStrings.showDashboard , sender: self)
    }

    func onErrorLogin(msg: String) {
        self.showErrorAlert(msg: msg)
    }
}
