//
//  LoginViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import Foundation
import FirebaseAuth
import Combine

protocol LoginService: AnyObject {
    func showLoader()
    func hideLoader()
    func onErrorLogin(msg: String)
    func onSuccessLogin()
    func onSuccessReset()
    func focusOnPassword()
}

class LoginViewModel {

    // MARK: - Variables

    private var service: LoginService?
    private var biometricsObservable: AnyCancellable?

    // MARK: - init method

    init(delegate: LoginService) {
        self.service = delegate
    }

    // MARK: - Public method

    public func performResetPassword(email: String) {
        self.service?.showLoader()
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else {
                fatalError("Failed to capture self, Reset password flow")
            }
            if error != nil {
                self.service?.hideLoader()
                self.service?.onErrorLogin(msg: error!.localizedDescription)
                return
            }
            self.service?.hideLoader()
            self.service?.onSuccessReset()
        }
    }

    public func performLoginWithBiometrics(email: String) {
        self.service?.showLoader()
        self.biometricsObservable = BiometricManager.shared.requestBioMetricAuthentication().sink { didFinish in
            switch didFinish {
            case .finished:
                print("finish loading biometrics")
            case .failure(_):
                self.service?.onErrorLogin(msg: AppStrings.errorLogin)
            }
        } receiveValue: { result in
            self.service?.hideLoader()
            switch result {
            case .success:
                guard let password = SecureStorageManager.getHashedPassword() else {
                    self.service?.onErrorLogin(msg: "No password was saved")
                    return
                }
                self.performLogIn(email: email, password: password)
            case .error(message: let message):
                self.service?.onErrorLogin(msg: message)
            case .errorWithTooManyAttempt(message: let message):
                self.service?.onErrorLogin(msg: message)
            case .appAuthentication:
                self.service?.focusOnPassword()
            }
        }

    }

    public func performLogIn(email: String, password: String) {
        self.service?.showLoader()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else {
                    fatalError("Failed to capture self, Login flow")
            }
            if error != nil {
                self.service?.hideLoader()
                self.service?.onErrorLogin(msg: error!.localizedDescription)
                return
            }
            guard let result = authResult else {
                self.service?.hideLoader()
                self.service?.onErrorLogin(msg: "No user ID found")
                return
            }
            SecureStorageManager.storeHashedPassword(hashedPassword: password)
            UserPreferences.shared?.loginUser(email: email, userID: result.user.uid)
            self.service?.onSuccessLogin()
        }
    }

    public func getWelcomeTitle() -> String {
        guard let preferences = UserPreferences.shared else { return AppStrings.welcomeAnonymous }
        guard preferences.isUserRegistered(),
              let userName = preferences.getUserName(),
              !userName.isEmpty else { return AppStrings.welcomeAnonymous }
        return String(format: AppStrings.welcomeUser, userName)
    }

    public func getEmailTitle() -> String? {
        guard let preferences = UserPreferences.shared else { return nil}
        guard preferences.isUserRegistered(),
              let userEmail = preferences.getUserEmail() else { return nil }
        return String(format: AppStrings.signInUser, userEmail)
    }

}
