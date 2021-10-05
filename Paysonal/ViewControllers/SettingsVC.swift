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

    // MARK: - Variables

    private var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SettingsViewModel(delegate: self)
        mainTableView.backgroundColor = .secondarySystemBackground
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.userNameLabel.text = UserPreferences.shared?.getUserName()
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

    // MARK: - Tableview methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0 :
            self.showNewNameAlert()
        case 1:
            UIApplication.shared.open(URL(string: AppConstants.privacy)!)
        case 2:
            UIApplication.shared.open(URL(string: AppConstants.termsAndConditions)!)
        case 3:
            UIApplication.shared.open(URL(string: "mailto:" + AppStrings.contactEmail)!)
        case 4:
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
