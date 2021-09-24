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

    // MARK: - Init methods

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Customisation methods

    func customise(transaction: Transaction ) {
        self.contentView.backgroundColor = .secondarySystemBackground
        self.containerView.layer.cornerRadius = 15
        self.dateLabel.text = transaction.date
        self.categoryLabel.text = transaction.category
        self.amountLabel.text = transaction.amount.description
    }
}
