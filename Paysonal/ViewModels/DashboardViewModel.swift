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

    // MARK: - Dummy data
    let dummyHousing = Entry(category: Categories.defaultCategories.Housing.rawValue)
    let dummyCar = Entry(category: Categories.defaultCategories.Car.rawValue)
    let dummyAmenities = Entry(category: Categories.defaultCategories.Amenities.rawValue)

    // MARK: - Init method
    init() {
        createDummyData()
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

    // MARK: - Private methods

    private func createDummyData() {
        let txHousing = [
            Transaction(amount: 12, date: "20.10.2021", category: Categories.defaultCategories.Housing.rawValue),
            Transaction(amount: 7, date: "18.10.2021", category: Categories.defaultCategories.Housing.rawValue),
            Transaction(amount: 11, date: "12.10.2021", category: Categories.defaultCategories.Housing.rawValue)
        ]
        dummyHousing.addMultipleTransactions(txHousing)

        let car = [
            Transaction(amount: 12, date: "20.10.2021", category: Categories.defaultCategories.Car.rawValue),
            Transaction(amount: 2, date: "18.10.2021", category: Categories.defaultCategories.Car.rawValue),
            Transaction(amount: 11, date: "12.10.2021", category: Categories.defaultCategories.Car.rawValue)
        ]
        dummyCar.addMultipleTransactions(car)

        let amenities = [
            Transaction(amount: 12, date: "20.10.2021", category: Categories.defaultCategories.Amenities.rawValue),
            Transaction(amount: 15, date: "18.10.2021", category: Categories.defaultCategories.Amenities.rawValue),
            Transaction(amount: 40, date: "12.10.2021", category: Categories.defaultCategories.Amenities.rawValue)
        ]
        dummyAmenities.addMultipleTransactions(amenities)

        dataEntries = [dummyHousing, dummyCar, dummyAmenities]
    }
}
