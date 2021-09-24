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
    
    let viewModel = DashboardViewModel()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chartView.delegate = self
        initUI()
    }

    // MARK: - Private methods

    private func initUI() {
        self.view.backgroundColor = .secondarySystemBackground

        self.transactionHistoryTableView.delegate = self
        self.transactionHistoryTableView.dataSource = self
        self.transactionHistoryTableView.backgroundColor = self.view.backgroundColor
        self.transactionHistoryTableView.register(
            UINib(nibName: "TransactionHistoryCell", bundle: nil),
            forCellReuseIdentifier: "TransactionHistoryCell"
        )

        self.monthLabel.text = viewModel.getDateForLabel()
        updatePieChartData()
    }

    private func updatePieChartData() {
        self.chartView.data = viewModel.getDataForChart()
        self.chartView.centerText = viewModel.getCenterText()
        self.chartView.transparentCircleColor = .secondarySystemBackground
        self.chartView.holeColor = .secondarySystemBackground
    }
}

// MARK: - Tableview methods

extension DashboardVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.headerView(forSection: section)?.backgroundView?.backgroundColor = .secondarySystemBackground
        return "Transaction History"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfCells()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryCell") as? TransactionHistoryCell,
              let transaction = viewModel.getTransaction(indexPath.row)
        else { return UITableViewCell() }
        cell.customise(transaction: transaction)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
