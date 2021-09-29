//
//  RegisterViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit
import FirebaseAuth

protocol RegisterService: AnyObject {
    func showErrorRegistering(msg: String)
    func onSuccessRegister()
    func showLoader()
    func hideLoader()
}

class RegisterViewModel {

    // MARK: - Variables

    private var service: RegisterService?

    // MARK: - Init methods

    init(delegate: RegisterService) {
        self.service = delegate
    }
    // MARK: - Public methods

    public func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    public func validatePassword(password: String) -> Bool {
        guard password.count > AppConstants.minPasswordLength else { return false }
        let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[_=~)(/,`#\\?!@$%^&*-+{}]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    public func performRegister(withEmail email: String, password: String, name: String?){
        self.service?.showLoader()
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { fatalError("Couldn't capture self on register flow") }
            if error != nil {
                self.service?.hideLoader()
                self.service?.showErrorRegistering(msg: error!.localizedDescription)
                return
            }
            guard let result = authResult else {
                self.service?.hideLoader()
                self.service?.showErrorRegistering(msg: "No user ID found")
                return
            }
            if let userName = name { UserPreferences.shared?.setUsername(with: userName) }
            UserPreferences.shared?.setUserEmail(with: email)
            UserPreferences.shared?.setUserID(id: result.user.uid)
            self.service?.hideLoader()
            self.service?.onSuccessRegister()
        }
    }
}
