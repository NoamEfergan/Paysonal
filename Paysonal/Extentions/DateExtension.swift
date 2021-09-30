//
//  DateExtension.swift
//  Paysonal
//
//  Created by Noam Efergan on 29/09/2021.
//

import Foundation

extension Date {

    /// Get the current month name in English, first later capitalised
    /// - Returns: String value of the current month
    public func getCurrentMonth() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }

    /// Get the current year name in English, first later capitalised
    /// - Returns: String value of the current year
    public func getCurrentYear() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: now)
    }


    /// Get the date in a string formatter as day/month/year
    /// - Returns: string describing the date
    public func getStringFromDate() -> String {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.dateFormat = "dd.MM.yy"
        return formater.string(from: self)
    }

    func getMonthFromString(_ dateString: String) -> String? {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.dateFormat = "dd.MM.yy"
        guard let date = formater.date(from: dateString) else { return nil}
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL"
        return monthFormatter.string(from: date)
    }

    func getYearFromString(_ dateString: String) -> String? {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.dateFormat = "dd.MM.yy"
        guard let date = formater.date(from: dateString) else { return nil}
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "YYYY"
        return monthFormatter.string(from: date)
    }

}
