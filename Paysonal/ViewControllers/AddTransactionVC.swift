//
//  AddTransactionVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 24/09/2021.
//

import UIKit

class AddTransactionVC: UIViewController {

    // MARK: - outlets

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadeBackground: UIView!

    // MARK: - Variables

    private static let viewModel = AddTransactionViewModel()

    // MARK: -Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.shadeBackground.backgroundColor = .black.withAlphaComponent(0.7)
        self.applyButton.tintColor = AppColors.tintColor
        self.containerView.layer.cornerRadius = 15
        self.containerView.backgroundColor = .secondarySystemBackground
    }

    // MARK: - Actions

    @IBAction func applyTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
