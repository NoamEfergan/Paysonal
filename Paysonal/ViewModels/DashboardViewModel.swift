//
//  DashboardViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit
import Charts

public class DashboardViewModel: ChartViewDelegate {

    let dummyData: [Transaction] = [
        Transaction(amount: "12", date: "20.10.2021"),
        Transaction(amount: "15", date: "18.10.2021"),
        Transaction(amount: "11", date: "12.10.2021"),
        Transaction(amount: "10", date: "12.10.2021"),
        Transaction(amount: "45", date: "23.10.2021")
    ]

    public func getDateForLabel() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }
}
