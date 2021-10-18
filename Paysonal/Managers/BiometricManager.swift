//
//  BiometricManager.swift
//  Paysonal
//
//  Created by Noam Efergan on 18/10/2021.
//

import Foundation
import Combine
import LocalAuthentication

final class BiometricManager {
    private(set) static var shared = BiometricManager()
    private let userDeniedFaceIDPermission = -6

    enum BiometricAuthResult {
        case success
        case error(message: String)
        case errorWithTooManyAttempt(message: String)
        case appAuthentication
    }

    enum BiometricType {
        case none
        case touch
        case face
    }

    /// Used for deciding the biometric type
    var biometricType: BiometricType {
        let authContext = LAContext()
        let canEvalute = authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if #available(iOS 12, *) {
            switch authContext.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        } else {
            return canEvalute ? .touch : .none
        }
    }

    /// Used for check biometric present or not
    var isBiometricPresent: Bool {
        let context = LAContext()
        return (context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil))
    }

    /// Used for deciding the biometric title
    var biometricTitle: String {
        switch biometricType {
        case .none:
            return ""
        case .touch:
            return AppStrings.login_fingerprint
        case .face:
            return AppStrings.login_faceID
        }
    }

    /// Used for deciding the biometric title
    var biometricAlertTitle: String {
        switch biometricType {
        case .none:
            return ""
        case .touch:
            return AppStrings.finger_not_registered
        case .face:
            return AppStrings.faceID_not_registered
        }
    }

    /// Used for deciding the biometric icon
    var biometricAlertSubtitle: String {
        switch biometricType {
        case .none:
            return ""
        case .touch:
            return AppStrings.register_fingerprint
        case .face:
            return AppStrings.register_faceID
        }
    }

    /// Used for adding the title on biometric screen
    var passwordVerification: String {
        switch biometricType {
        case .none:
            return ""
        case .touch:
            return AppStrings.enterPassFinger
        case .face:
            return AppStrings.enterPassFaceID
        }
    }

    /// Checks and disables the biometric auth if the user has removed it from the device settings
    func disableBiometricAuthIfRemovedFromDevice() {
        // Check if user has disabled biometric auth from the device. Nothing needs to be done if the
        // device biometric auth setting was not changed or it was never registered.
        if !isBiometricRegistered() {
            UserPreferences.shared?.setUserBiometrics(isOn: false)
        }
    }

    func requestBioMetricAuthentication() -> Future<BiometricAuthResult, Error> {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"
        return Future { promise in
        if localAuthenticationContext.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &authError
            ) {
            localAuthenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reasonString
            ) { [weak self] success, evaluateError in
                OperationQueue.main.addOperation {
                    guard let this = self else {
                        let error = NSError(domain: "No userID", code: 1, userInfo: nil)
                        promise(.failure(error))
                        return }
                    if success {
                        promise(.success(.success))
                    } else {
                        guard let error = evaluateError else { return }

                        if let authError = this.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code) {
                            promise(.success(authError))
                        } else {
                            localAuthenticationContext.invalidate()
                            let _:AnyCancellable = this.requestUserAuthWithPasscode().sink { didFinish in
                                switch didFinish {
                                case .finished:
                                    print("did finish biometrics with password")
                                case .failure(_):
                                    promise(.failure(error))
                                }
                            } receiveValue: { result in
                                promise(.success(result))
                            }
                        }
                    }
                }
            }
        } else {
            guard let error = authError else { return }
            if let authError = self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code) {
                promise(.success(authError))
            } else {
                let _:AnyCancellable = self.requestUserAuthWithPasscode().sink { didFinish in
                    switch didFinish {
                    case .finished:
                        print("did finish biometrics with password")
                    case .failure(_):
                        promise(.failure(error))
                    }
                } receiveValue: { result in
                    promise(.success(result))
                }

            }

        }
        }
    }

    func requestUserAuthWithPasscode() -> Future<BiometricAuthResult, Error> {
        let localAuthenticationContext = LAContext()

        let reasonString = "To access the secure data"
        return Future { promise in
        localAuthenticationContext.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reasonString
        ) { [weak self] success, evaluateError in
            OperationQueue.main.addOperation {
                guard let this = self else { return }
                if success {
                    promise(.success(.success))
                } else {
                    guard let error = evaluateError else { return }

                    if let auth = this.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code) {
                        promise(.success(auth))
                    }
                }
            }
        }
        }
    }

    func isBiometricRegistered() -> Bool {
        let context = LAContext()
        var error: NSError?
        let flag = (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error))
        if error != nil && error?.code == userDeniedFaceIDPermission {
            return false
        }
        return flag
    }

    private func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> BiometricAuthResult? {
        let context = LAContext()
        (context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil))
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                return .error(message: "Biometrics are not supported on your device")

            case LAError.biometryLockout.rawValue:
                return .errorWithTooManyAttempt(message:"Too many attempts, biometrics have been locked out.")

            case LAError.biometryNotEnrolled.rawValue:
                return .error(message: "You are not enrolled to use biometrics")

            default:
                return .error(message: "Oops! something went wrong")
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                 return .error(message: "Failed due to being locked our for too many attempts")

            case LAError.touchIDNotAvailable.rawValue:
                 return .error(message: "Biometrics are not supported on your device")

            case LAError.touchIDNotEnrolled.rawValue:
                return .error(message: "You are not enrolled to use biometrics")

            default:
                return .error(message: "Oops! something went wrong")
            }
        }
    }

    private func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> BiometricAuthResult? {
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            return .error(message: "You failed to provide valid credentials")

        case LAError.appCancel.rawValue:
            return .error(message: "Authentication was cancelled by application")

        case LAError.invalidContext.rawValue, LAError.notInteractive.rawValue:
            return .error(message: "Oops! something went wrong")

        case LAError.passcodeNotSet.rawValue:
            return .error(message: "Passcode is not set on the device")

        case LAError.systemCancel.rawValue:
            return .error(message: "Authentication was cancelled by the device")

        case LAError.userFallback.rawValue:
            return .appAuthentication

        case LAError.userCancel.rawValue:
           return .appAuthentication

        default:
            return evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
    }
}

