//
//  UserTransactionsManager.swift
//  Paysonal
//
//  Created by Noam Efergan on 27/09/2021.
//

import UIKit

public class UserTransactionsManager {

    // MARK: - Variables

    private(set) static var shared: UserTransactionsManager?

    // MARK: - Dummy data
    private let dummyHousing = Entry(category: "House")
    private let dummyCar = Entry(category: "Car")
    private let dummyAmenities = Entry(category: "Aminities")
    private var dataEntries: [Entry] = []

    // MARK: - Init methods

    class func initialise() {
        if shared == nil { shared = UserTransactionsManager() }
    }

    init() {
        createDummyData()
    }

    // Dummy Data

    public func getEntries() -> [Entry] {
        return dataEntries
    }

    private func createDummyData(){
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
