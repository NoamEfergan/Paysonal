//
//  DashboardViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit
import Charts
import Combine

protocol DashboardService: AnyObject {
    func didReceiveEntries()
    func errorReceivingEntries(msg: String)
}

public class DashboardViewModel: ChartViewDelegate {

    // MARK: - Variables

    private var transactions: [Transaction] = []
    private var entriesObserver: AnyCancellable?
    private var service: DashboardService?
    private var entries: [Entry] = []

    // MARK: - Init method
    init(delegate: DashboardService) {
        self.service = delegate
        self.addObserver()
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

    private func addObserver() {
        if let userPreferences = UserTransactionsManager.shared {
        self.entriesObserver = userPreferences.getTransactionsForCurrentMonth()
            .sink(receiveCompletion: { [weak self] didFinish in
                switch didFinish {
                case .finished:
                    print("finish loading transaction successfully ")
                case .failure(_):
                    self?.service?.errorReceivingEntries(msg: AppStrings.fetchingError)
                }
            }, receiveValue: { [weak self] entries in
                self?.entries = entries
                self?.getAllTransactions()
                self?.service?.didReceiveEntries()
            })
        }
    }

    private func getAllTransactions() {
        self.transactions = []
        for entry in entries {
            self.transactions += entry.getTransactions()
        }
    }
}
