//
//  CountdownsListViewModel.swift
//  CountdownsListViewModel
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Combine
import Foundation
import SwiftUI

class CountdownsListViewModel: ObservableObject {
  @Published private(set) var futureCountdowns: [Countdown] = []
  @Published private(set) var pastCountdowns: [Countdown] = []

  private let countdownService: CountdownService = .shared
  private var cancellables: Set<AnyCancellable> = []

  var sortingCriteria: SortingCriteria {
    get {
      countdownService.sortingCriteria
    }
    set {
      countdownService.setSortingCriteria(newValue)
    }
  }

  init() {
    countdownService.$countdowns
      .combineLatest(countdownService.$sortingCriteria.removeDuplicates())
      .receive(on: DispatchQueue.main)
      .sink { [weak self] countdowns, criteria in
        self?.refreshCountdowns(newCountdowns: countdowns, sortingCriteria: criteria)
      }
      .store(in: &cancellables)

    NotificationCenter.default.publisher(for: .countdownDidChangeExpirationStatus)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.refreshCountdowns(newCountdowns: self.countdownService.countdowns, sortingCriteria: self.countdownService.sortingCriteria)
      }
      .store(in: &cancellables)
  }

  private func refreshCountdowns(newCountdowns countdowns: [Countdown], sortingCriteria: SortingCriteria) {
    print("refreshing countdowns (\(sortingCriteria))")
    pastCountdowns = []
    futureCountdowns = []

    countdowns.sorted { lhs, rhs in
      switch sortingCriteria {
      case .timeLeft:
        return lhs.target < rhs.target
      case .creation:
        return lhs.createdAt > rhs.createdAt
      }
    }
    .forEach { countdown in
      if countdown.inThePast {
        pastCountdowns.append(countdown)
      } else {
        futureCountdowns.append(countdown)
      }
    }
  }

  func removeFutureCountdowns(at offsets: IndexSet) {
    countdownService.removeCountdowns(offsets.map { futureCountdowns[$0] })
  }

  func removePastCountdowns(at offsets: IndexSet) {
    countdownService.removeCountdowns(offsets.map { pastCountdowns[$0] })
  }
}
