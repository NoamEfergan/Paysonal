//
//  ViewController.swift
//  Paysonal
//
//  Created by Noam Efergan on 23/09/2021.
//

import UIKit
import Charts

class DashboardVC: UIViewController {

    // MARK: -  Outlets

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!

    // MARK: - Variables
    
    let viewModel = DashboardViewModel()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.monthLabel.text = viewModel.getDateForLabel()
        updatePieChartData()
    }

    // MARK: - Private methods

    private func updatePieChartData() {
        self.chartView.data = viewModel.getDataForChart()
        self.chartView.centerText = viewModel.getCenterText()
    }
}

