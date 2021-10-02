//
//  ChooseDateAlertVC.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import UIKit

class ChooseDateAlertVC: UIViewController {

    // MARK: - Variables

    private var viewModel: ChooseDateViewModel!
    private var yearsAndMonths: ([String], [String])!

    // MARK: - Outlets

    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noHistoryLabel: UILabel!
    
    // MARK: - Init methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.viewModel = ChooseDateViewModel(delegate: self)
        viewModel.fetchYears()
        self.yearsAndMonths = viewModel.getYearsAndMonths()
        datePicker.dataSource = self
        datePicker.delegate = self
        self.containerView.addDropShadow()
    }

    // MARK: - Actions

    @IBAction func didTapApply(_ sender: UIButton) {
    }

    @IBAction func didTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

// MARK: - Picker delegate methods

extension ChooseDateAlertVC: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if yearsAndMonths.0.count == 0 {
            self.datePicker.isHidden = true
            self.noHistoryLabel.isHidden = false
        } else {
            self.datePicker.isHidden = false
            self.noHistoryLabel.isHidden = true
        }
        return (component == 0 ? yearsAndMonths.0.count : yearsAndMonths.1.count)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (component == 0 ? yearsAndMonths.0[row] : yearsAndMonths.1[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.viewModel.getMonthsForYear(year: yearsAndMonths.0[row])
        }
    }

}

// MARK: - Protocol methods

extension ChooseDateAlertVC: ChooseDateService {

    func showLoader() {
        self.view.showLoader(message: nil)
    }

    func hideLoader() {
        self.view.hideLoader()
    }

    func showError(msg: String) {
        self.showErrorAlert(msg: msg)
    }

    func didLoadYearsAndMonths() {
        self.yearsAndMonths = viewModel.getYearsAndMonths()
        self.datePicker.reloadAllComponents()
    }
}
