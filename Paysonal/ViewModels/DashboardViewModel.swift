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
    // This one is in charge of the initial entries coming from the Firestore
    private var entriesObserver: AnyCancellable?
    private var service: DashboardService?
    private var entries: [Entry] = []

    // MARK: - Init method
    init(delegate: DashboardService) {
        self.service = delegate
        self.addObserver()
        self.addSubscribers()
    }

    deinit {
        self.removeSubscribers()
    }

    // MARK: - Public methods

    public func getDataForChart() -> PieChartData {
        var pieChartDataEntries: [PieChartDataEntry] = []
        var colors: [NSUIColor] = []
        for entry in entries {
            pieChartDataEntries.append(PieChartDataEntry(value: entry.getTotalValue(), label: entry.category.name))
            colors.append(UIColor.init(hex: entry.category.colorHex))
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
        if entries.isEmpty {
            return AppStrings.nothingToShow
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

    private func addSubscribers() {
        // New entry has been made, means new category and new transaction
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newEntryReceived),
            name: .newEntry,
            object: nil
        )
        // New transaction has been made
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newTransactionReceived),
            name: .newTransaction,
            object: nil
        )
    }

    private func removeSubscribers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .newEntry,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .newTransaction,
            object: nil
        )
    }

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
        sortTransactions()
    }

    private func sortTransactions() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        self.transactions = transactions.sorted(by: {
            dateFormatter.date(from:$0.date)!.compare(dateFormatter.date(from:$1.date)!) == .orderedAscending
        })
    }


    @objc private func newEntryReceived() {
        guard let manager = UserTransactionsManager.shared else { return }
        self.entries = manager.getEntries()
        self.getAllTransactions()
        self.service?.didReceiveEntries()
    }

    @objc private func newTransactionReceived() {
        getAllTransactions()
        self.service?.didReceiveEntries()
    }
}
