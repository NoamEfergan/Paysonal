//
//  TransactionHistoryCell.swift
//  Paysonal
//
//  Created by Noam Efergan on 24/09/2021.
//

import UIKit

class TransactionHistoryCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    public var didTapDelete:(()-> Void)?

    // MARK: - Init methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Customisation methods

    func customise(transaction: Transaction ) {
        self.contentView.backgroundColor = .secondarySystemBackground
        self.containerView.layer.cornerRadius = AppConstants.cornerRad
        self.dateLabel.text = transaction.date
        self.categoryLabel.text = transaction.category.name
        self.amountLabel.text = transaction.amount.description
    }

    // MARK: - Actions

    @IBAction func deleteButtonWasTapped(_ sender: UIButton) {
        didTapDelete?()
    }

}
