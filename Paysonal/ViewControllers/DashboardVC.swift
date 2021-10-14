//
//  ViewController.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit
import Charts

class DashboardVC: UIViewController, ChartViewDelegate {

    // MARK: -  Outlets

    @IBOutlet weak var transactionHistoryTableView: UITableView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!

    // MARK: - Variables
    
    var viewModel: DashboardViewModel!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DashboardViewModel(delegate: self)
        self.chartView.delegate = self
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.view.showLoader(message: nil)
        self.view.backgroundColor = .secondarySystemBackground
        self.chartView.transparentCircleColor = .secondarySystemBackground
        self.chartView.holeColor = .secondarySystemBackground
        self.transactionHistoryTableView.delegate = self
        self.transactionHistoryTableView.dataSource = self
        self.transactionHistoryTableView.backgroundColor = self.view.backgroundColor
        self.transactionHistoryTableView.register(
            UINib(nibName: NibNames.transactionHistoryCell, bundle: nil),
            forCellReuseIdentifier: NibNames.transactionHistoryCell
        )

        self.monthLabel.text = Date().getCurrentMonth()
        updatePieChartData()
    }

    private func updatePieChartData() {
        self.chartView.data = viewModel.getDataForChart()
        self.chartView.centerText = viewModel.getCenterText()
    }

    private func didTapDeleteCell(location: Int) {
        let cancelAction = UIAlertAction(
            title: AppStrings.delete,
            style: .destructive) { _ in
                self.viewModel.removeTransaction(at: location)
            }
        self.showActionAlert(msg: AppStrings.verifyDeleteTx, action: cancelAction)
    }

    // MARK: - Actions

    @IBAction func monthSelectionButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: NibNames.chooseDate, bundle: .main)
        let popupVC = storyboard.instantiateViewController(withIdentifier: NibNames.chooseDate + "VC")
        as! ChooseDateAlertVC
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        present(popupVC, animated: true, completion: nil)
    }
}

// MARK: - Tableview methods

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.headerView(forSection: section)?.backgroundView?.backgroundColor = .secondarySystemBackground
        return AppStrings.transactionHistoryTitle
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NibNames.transactionHistoryCell)
                as? TransactionHistoryCell else { return UITableViewCell() }
        let transaction = viewModel.transactions[indexPath.row]
        cell.customise(transaction: transaction)
        cell.didTapDelete = { self.didTapDeleteCell(location: indexPath.row) }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - Protocol methods

extension DashboardVC: DashboardService {

    func didReceiveEntries(monthTitle: String) {
        self.view.hideLoader()
        self.monthLabel.text = monthTitle
        self.updatePieChartData()
        self.transactionHistoryTableView.reloadData()
    }

    func errorReceivingEntries(msg: String) {
        self.view.hideLoader()
        self.showErrorAlert(msg: msg)
    }

    func showLoader() {
        self.view.showLoader(message: nil)
    }

    func hideLoader() {
        self.view.hideLoader()
    }
}
