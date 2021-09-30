//
//  StringExtension.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import UIKit

extension Optional where Wrapped == String {

    func isEmptyOrNil() -> Bool {
        guard let self = self else { return true }
        return self == ""
    }
}
