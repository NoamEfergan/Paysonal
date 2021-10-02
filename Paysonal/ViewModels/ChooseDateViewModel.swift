//
//  ChooseMonthViewModel.swift
//  Paysonal
//
//  Created by Noam Efergan on 30/09/2021.
//

import Foundation
import Combine

protocol ChooseDateService: AnyObject {
    func showLoader()
    func hideLoader()
    func showError(msg:String)
    func didLoadYearsAndMonths()
}

class ChooseDateViewModel {

    // MARK: - Variables

    private var service: ChooseDateService!
    private var yearsObserver: AnyCancellable?
    private var monthsObserver: AnyCancellable?
    private var years: [String] = []
    private var months: [String] = []

    private var monthsForYear:[String: [String]] = [:]

    // MARK: - Init method

    init(delegate: ChooseDateService) {
        self.service = delegate
    }

    // MARK: - Public methods

    public func fetchYears() {
        self.service.showLoader()
        self.yearsObserver = UserPreferences.shared?.getYearsWithTransactions()
            .sink(receiveCompletion: { didFinish in
                self.service.hideLoader()
                switch didFinish {
                case .finished:
                    print("Finished")
                case .failure(_):
                    self.service.showError(msg: AppStrings.errorLoading)
                }
            }, receiveValue: { years in
                self.years = years
                if !years.isEmpty {
                    self.getAllMonths(for: years)
                }
                else {
                    self.service.hideLoader()
                }
            })
    }

    public func getMonthsForYear(year: String) {
        guard let monthsForGivenYear = monthsForYear[year] else {
            self.service.showError(msg: AppStrings.somethingWentWrong)
            return
        }
        self.months = monthsForGivenYear
        self.service.didLoadYearsAndMonths()
    }

    public func getYearsAndMonths() -> ([String],[String]) {
        return (years,months)
    }

    // MARK: - Private methods


    /// Asynchronously fetch all the months with transactions for the given years
    /// - Parameter years: String array for all the years
    private func getAllMonths(for years: [String]) {
        // Create async management
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: AppConstants.kYears)
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        // Go in
        dispatchQueue.async {
            for year in years {
                dispatchGroup.enter()
                self.monthsObserver = UserPreferences.shared?.getMonthsWithTransactions(year: year)
                    .sink(receiveCompletion: { didFinish in
                        switch didFinish {
                        case .finished:
                            print("Finished")
                        case .failure(_):
                            self.service.showError(msg: AppStrings.errorLoading)
                        }
                    }, receiveValue: { months in
                        self.monthsForYear[year] = months
                        dispatchSemaphore.signal()
                        dispatchGroup.leave()
                    })
                // Tell the dispatch to wait until all are done
                dispatchSemaphore.wait()
            }
            // Once the loop has finished, let the VC know
            dispatchGroup.notify(queue: dispatchQueue) {
                DispatchQueue.main.async {
                    self.months = self.monthsForYear.first?.value ?? []
                    self.service.didLoadYearsAndMonths()
                    self.service.hideLoader()
                }
            }

        }
    }

}
