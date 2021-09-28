//
//  LoginVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit

class LoginVC: UIViewController, UIPopoverPresentationControllerDelegate {

    // MARK: - Outlets

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
    }

    func adaptivePresentationStyle(
        for _: UIPresentationController, traitCollection _: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: - Actions

    @IBAction func registerTapped(_ sender: Any) {
        navigateToRegister()
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
