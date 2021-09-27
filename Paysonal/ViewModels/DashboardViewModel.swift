//
//  DashboardViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit
import Charts

public class DashboardViewModel: ChartViewDelegate {

    // MARK: - Variables

    private var transactions: [Transaction] = []

    // MARK: - Init method
    init() {
        getAllTransactions()
    }

    // MARK: - Public methods

    public func getDateForLabel() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }

    public func getDataForChart() -> PieChartData {
        var pieChartDataEntries: [PieChartDataEntry] = []
        var colors: [NSUIColor] = []
        guard let entries = UserTransactionsManager.shared?.getEntries() else { return PieChartData(dataSets: nil) }
        for entry in entries {
            pieChartDataEntries.append(PieChartDataEntry(value: entry.getTotalValue(), label: entry.category))
            colors.append(entry.color)
    }
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        dataSet.colors = colors
        return PieChartData(dataSet: dataSet)
    }

    public func getCenterText() -> String {
        var amounts = 0.0
        guard let entries = UserTransactionsManager.shared?.getEntries() else { return "error "}
        for entry in entries {
            amounts += entry.getTotalValue()
        }
        return AppStrings.totalSpent + "\(amounts)"
    }

    public func getTransaction(_ location: Int) -> Transaction? {
        guard !(location > transactions.count) else { return nil }
        return transactions[location]
    }

    public func getNumberOfCells() -> Int {
        return transactions.count
    }

    // MARK: - Private methods

    private func getAllTransactions() {
        self.transactions = []
        guard let entries = UserTransactionsManager.shared?.getEntries() else { return }
        for entry in entries {
            self.transactions += entry.getTransactions()
        }
    }
}
