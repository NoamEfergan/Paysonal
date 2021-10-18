//
//  CurrencySymbols.swift
//  Paysonal
//
//  Created by Noam Efergan on 14/10/2021.
//

import Foundation

enum CurrencySymbols: String, CaseIterable {
    case dollar = "$"
    case euro = "€"
    case pound = "£"
    case shekels = "₪"
    case yen = "¥"

    func getSFSymbol() -> String {
        switch self {
        case .dollar:
            return "dollarsign.circle"
        case .euro:
            return "eurosign.circle"
        case .pound:
            return "sterlingsign.circle"
        case .shekels:
            return "shekelsign.circle"
        case .yen:
            return "yensign.circle"
        }
    }
}
