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
    func didReceiveEntries(monthTitle: String)
    func errorReceivingEntries(msg: String)
    func showLoader()
    func hideLoader()
}

public class DashboardViewModel: ChartViewDelegate {

    // MARK: - Variables

    private(set) var transactions: [Transaction] = [] {
        didSet {
            self.service?.didReceiveEntries(monthTitle: getRelevantMonthForDisplay())
        }
    }
    // This one is in charge of the initial entries coming from the Firestore
    private var entriesObserver: AnyCancellable?
    private var service: DashboardService?
    private var entries: [Entry] = []
    private var incomes: [SourceOfIncome] = []

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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = UserPreferences.shared?.getUserSelectedCurrency() ?? "$"
        let amountsString = formatter.string(from: NSNumber(value: amounts)) ?? "--"
        return AppStrings.totalSpent + amountsString
    }

    public func removeTransaction(at location: Int) {
        let transactionToBeRemoved = transactions[location]
        guard let txMonth = Date().getMonthFromString(transactionToBeRemoved.date),
              let txYear = Date().getYearFromString(transactionToBeRemoved.date) else {
                  self.service?.errorReceivingEntries(msg: AppStrings.somethingWentWrong)
                  return
              }
        self.removeTransactionFromEntries(tx: transactionToBeRemoved)
        UserTransactionsManager.shared?.removeTransaction(
            year: txYear,
            month: txMonth,
            txDate: transactionToBeRemoved.date
        )
        self.service?.didReceiveEntries(monthTitle: self.getRelevantMonthForDisplay())
    }

    // MARK: - Private methods

    private func removeTransactionFromEntries(tx: Transaction) {
        for entry in entries {
            for transaction in entry.getTransactions() {
                if transaction == tx { entry.removeTransaction(tx: tx) }
            }
        }
    }

    private func getAllTransactions() {
        self.transactions = []
        for entry in entries {
            self.transactions += entry.getTransactions()
        }
        for income in incomes {
            let category = Category(name: income.name, colorHex: AppConstants.kSources)
            let tx = Transaction(amount: income.amount, date: income.date, category: category)
            self.transactions.append(tx)
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

    private func getRelevantMonthForDisplay() -> String {
        if self.transactions.isEmpty {
            return Date().getCurrentMonth()
        } else {
            return Date().getMonthFromString(self.transactions.first!.date) ?? Date().getCurrentMonth()
        }
    }

    // MARK: - Notification methods

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
        // A different month has been selected
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newDateReceived),
            name: .selectedDate,
            object: nil
            )
        // New source of income was received
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newIncomeReceived),
            name: .newIncome,
            object: nil
            )
        // User selected a new currency
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newIncomeReceived),
            name: .newCurrency,
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
        NotificationCenter.default.removeObserver(
            self,
            name: .selectedDate,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .newIncome,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .newCurrency,
            object: nil
        )
    }

    private func addObserver() {
        if let transactionManager = UserTransactionsManager.shared {
        self.entriesObserver = transactionManager.fetchTransactions()
            .sink(receiveCompletion: { [weak self] didFinish in
                switch didFinish {
                case .finished:
                    print("finish loading transaction successfully ")
                case .failure(_):
                    self?.service?.errorReceivingEntries(msg: AppStrings.fetchingError)
                }
            }, receiveValue: { [weak self] data in
                self?.entries = data.0
                self?.incomes = data.1
                self?.getAllTransactions()
                self?.service?.didReceiveEntries(monthTitle: self!.getRelevantMonthForDisplay())
            })
        }
    }

    // MARK: - Objective C methods

    @objc private func newCurrencyReceived() {
        self.service?.didReceiveEntries(monthTitle: getRelevantMonthForDisplay())
    }

    @objc private func newIncomeReceived() {
        guard let manager = UserTransactionsManager.shared else { return }
        self.incomes = manager.sourcesOfIncome
        getAllTransactions()
    }

    @objc private func newEntryReceived() {
        guard let manager = UserTransactionsManager.shared else { return }
        self.entries = manager.getEntries().filter({!$0.getTransactions().isEmpty})
        self.getAllTransactions()
        self.service?.didReceiveEntries(monthTitle: Date().getCurrentMonth())
    }

    @objc private func newTransactionReceived() {
        getAllTransactions()
        self.service?.didReceiveEntries(monthTitle: getRelevantMonthForDisplay())
    }

    @objc private func newDateReceived(_ notification: Notification) {
        self.service?.showLoader()
        guard let year = notification.userInfo?[AppConstants.kYears] as? String,
              let month = notification.userInfo?[AppConstants.kMonths] as? String,
        let transactionManager = UserTransactionsManager.shared else {
            self.service?.errorReceivingEntries(msg: AppStrings.somethingWentWrong)
            return
        }
        self.entriesObserver = transactionManager.fetchTransactions(year: year, month: month)
            .sink(receiveCompletion: { [weak self] didFinish in
                switch didFinish {
                case .finished:
                    self?.service?.hideLoader()
                    print("finish loading transaction successfully ")
                case .failure(_):
                    self?.service?.errorReceivingEntries(msg: AppStrings.fetchingError)
                }
            }, receiveValue: { [weak self] data in
                self?.entries = data.0
                self?.incomes = data.1
                self?.getAllTransactions()
                self?.service?.didReceiveEntries(monthTitle: month)
            })
    }
}
