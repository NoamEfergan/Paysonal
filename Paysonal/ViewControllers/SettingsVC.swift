//
//  SettingsVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit

class SettingsVC: UITableViewController {

    // MARK: - Outlets

    @IBOutlet var mainTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginWithBiometricsLabel: UILabel!
    @IBOutlet weak var biometricsCell: UITableViewCell!
    @IBOutlet weak var coinCell: UITableViewCell!
    
    // MARK: - Variables

    private var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SettingsViewModel(delegate: self)
        mainTableView.backgroundColor = .secondarySystemBackground
        initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSubscriber()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeSubscriber()
    }

    // MARK: - Private methods

    private func addSubscriber() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveNewCurrency),
            name: .newCurrency,
            object: nil
        )
    }

    private func removeSubscriber() {
        NotificationCenter.default.removeObserver(self, name: .newCurrency, object: nil)
    }

    @objc private func didReceiveNewCurrency() {
        addCoinButton()
    }

    private func initUI() {
        self.userNameLabel.text = UserPreferences.shared?.getUserName()
        self.loginWithBiometricsLabel.text = UserPreferences.shared!.isBiometricsEnabled
        ? AppStrings.biometrics_on
        : AppStrings.biometrics_off
        addBiometricsButton()
        addCoinButton()
    }

    private func addCoinButton() {
        let button = UIButton(type:.roundedRect)
        let selectedCurrency = UserPreferences.shared?.getUserSelectedCurrency() ?? "$"
        let symbol = CurrencySymbols(rawValue: selectedCurrency) ?? .dollar
        button.setImage(UIImage(systemName: symbol.getSFSymbol())!, for: .normal)
        button.tintColor = UIColor(named: "TintColor")
        button.sizeToFit()
        button.addTarget(nil, action: #selector(goToCurrencySelections), for: .touchUpInside)
        coinCell.accessoryView = button
    }

    private func addBiometricsButton() {
        let button = UIButton(type:.roundedRect)
        let imageName = UserPreferences.shared!.isBiometricsEnabled
        ? "square.dashed.inset.filled"
        : "square.dashed"
        button.setImage(UIImage(systemName: imageName)!, for: .normal)
        button.tintColor = UIColor(named: "TintColor")
        button.sizeToFit()
        button.addTarget(nil, action: #selector(adjustBiometrics), for: .touchUpInside)
        self.biometricsCell.accessoryView = button
    }

    private func showNewNameAlert() {
        let alert = viewModel.getNewNameAlert()
        self.present(alert, animated: true, completion: nil)
    }

    private func showLogoutAlert() {
        self.showActionAlert(
            msg: AppStrings.logoutMsg,
            action: UIAlertAction(
                title: AppStrings.logoutTitle,
                style: .destructive,
                handler: { _ in
                    UserPreferences.shared?.resetUser()
                    self.performSegue(withIdentifier: AppStrings.showLogin, sender: nil)
                }))
    }

    private func showEditCategoriesAlert() {
        let storyboard = UIStoryboard(name: NibNames.editCategory, bundle: .main)
        let popupVC = storyboard.instantiateViewController(withIdentifier: NibNames.editCategory + "VC")
        as! EditCategoryAlertVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }

    // MARK: - Objective C methods

    @objc private func goToCurrencySelections() {
        self.performSegue(withIdentifier: AppStrings.showCurrencies, sender: nil)
    }

    @objc private func adjustBiometrics() {
        guard BiometricManager.shared.isBiometricRegistered() else {
            self.showError(msg: BiometricManager.shared.biometricAlertSubtitle)
            return
        }
        let currentState = UserPreferences.shared!.isBiometricsEnabled
        UserPreferences.shared?.setUserBiometrics(isOn: !currentState)
        addBiometricsButton()
    }

    // MARK: - Tableview methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
            // User Preferences
        case 0:
            switch indexPath.row {
            case 0:
                self.showNewNameAlert()
            case 1:
                showEditCategoriesAlert()
            case 2:
                goToCurrencySelections()
            case 3:
                adjustBiometrics()
            default:
                return
            }
            // General settings
        case 1:
            switch indexPath.row {
            case 0:
                UIApplication.shared.open(URL(string: AppConstants.termsAndConditions)!)
            case 1:
                UIApplication.shared.open(URL(string: AppConstants.privacy)!)
            case 2:
                UIApplication.shared.open(URL(string: "mailto:" + AppStrings.contactEmail)!)
            default:
                return
            }
            // Logout
        case 2:
            self.showLogoutAlert()
        default:
            return
        }
    }
}

// MARK: - Protocol methods

extension SettingsVC: SettingsService {
    
    func showError(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func didChangeName() {
        self.userNameLabel.text = UserPreferences.shared?.getUserName()
    }
}
