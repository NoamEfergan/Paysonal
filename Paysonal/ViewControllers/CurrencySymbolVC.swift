//
//  CurrencySymbolVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 14/10/2021.
//

import UIKit

class CurrencySymbolVC: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CurrencySymbols.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        var config = cell.defaultContentConfiguration()
        config.text = CurrencySymbols.allCases[indexPath.row].rawValue
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        UserPreferences.shared?.setUserSelectedCurrency(CurrencySymbols.allCases[indexPath.row].rawValue)
        self.dismiss(animated: true, completion: nil)
    }

}
