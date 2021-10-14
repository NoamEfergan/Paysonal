//
//  NotificationNameExtension.swift
//  Paysonal
//
//  Created by Noam Efergan on 29/09/2021.
//

import Combine
import Foundation

extension Notification.Name {
    static let newEntry = Notification.Name("newEntry")
    static let newCategory = Notification.Name("newCategory")
    static let newTransaction = Notification.Name("newTransaction")
    static let selectedDate = Notification.Name("selectedDate")
    static let newIncome = Notification.Name("NewIncome")
}
