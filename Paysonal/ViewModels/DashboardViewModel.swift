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

    private var dataEntries: [Entry] = []
    private var transactions: [Transaction] = []

    // MARK: - Dummy data
    let dummyHousing = Entry(category: "House")
    let dummyCar = Entry(category: "Car")
    let dummyAmenities = Entry(category: "Aminities")

    // MARK: - Init method
    init() {
        createDummyData()
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
        for entry in dataEntries {
            pieChartDataEntries.append(PieChartDataEntry(value: entry.getTotalValue(), label: entry.category))
            colors.append(entry.color)
    }
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: nil)
        dataSet.colors = colors
        return PieChartData(dataSet: dataSet)
    }

    public func getCenterText() -> String {
        var amounts = 0.0
        for entry in dataEntries {
            amounts += entry.getTotalValue()
        }
        return "Total spent this month: \n\(amounts)"
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
        for entry in dataEntries {
            self.transactions += entry.getTransactions()
        }
    }

    private func createDummyData() {
        let categoryHousing = UserPreferences.shared?.getDefaultCategories().first ?? "nil"
        let txHousing = [
            Transaction(amount: 12, date: "20.10.2021", category: categoryHousing),
            Transaction(amount: 7, date: "18.10.2021", category: categoryHousing),
            Transaction(amount: 11, date: "12.10.2021", category: categoryHousing)
        ]
        dummyHousing.addMultipleTransactions(txHousing)
        let categoryCar = UserPreferences.shared?.getDefaultCategories()[1] ?? "nil car"
        let car = [
            Transaction(amount: 12, date: "20.10.2021", category: categoryCar),
            Transaction(amount: 2, date: "18.10.2021", category: categoryCar),
            Transaction(amount: 11, date: "12.10.2021", category: categoryCar)
        ]
        dummyCar.addMultipleTransactions(car)
        let categoryAmenities = UserPreferences.shared?.getDefaultCategories()[2] ?? "nil amenities"
        let amenities = [
            Transaction(amount: 12, date: "20.10.2021", category: categoryAmenities),
            Transaction(amount: 15, date: "18.10.2021", category: categoryAmenities),
            Transaction(amount: 40, date: "12.10.2021", category: categoryAmenities)
        ]
        dummyAmenities.addMultipleTransactions(amenities)

        dataEntries = [dummyHousing, dummyCar, dummyAmenities]
    }
}
