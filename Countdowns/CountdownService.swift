//
//  CountdownService.swift
//  CountdownService
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Foundation

class CountdownService: ObservableObject {
  static let shared = CountdownService()

  @Published private(set) var countdowns: [Countdown]
  @Published private(set) var sortingCriteria: SortingCriteria

  private let userDefaults: UserDefaults = .standard

  private init() {
    countdowns = userDefaults.loadCountdowns()
    sortingCriteria = userDefaults.loadSortingCriteria()
  }

  func addCountdown(_ countdown: Countdown) {
    defer {
      userDefaults.storeCountdowns(countdowns)
    }
    countdowns.append(countdown)
  }

  func removeCountdowns(_ shouldRemove: [Countdown]) {
    defer {
      userDefaults.storeCountdowns(countdowns)
    }
    countdowns = countdowns.filter { !shouldRemove.contains($0) }
  }

  func setSortingCriteria(_ sortingCriteria: SortingCriteria) {
    defer {
      userDefaults.storeSortingCriteria(sortingCriteria)
    }
    self.sortingCriteria = sortingCriteria
  }
}

private extension UserDefaults {
  enum Keys: String {
    case countdowns
    case sortingCriteria
  }

  func loadCountdowns() -> [Countdown] {
    guard let data = data(forKey: Keys.countdowns.rawValue) else { return [] }
    let countdowns = try? JSONDecoder().decode([Countdown].self, from: data)
    return countdowns ?? []
  }

  func storeCountdowns(_ countdowns: [Countdown]) {
    guard let data = try? JSONEncoder().encode(countdowns) else { return }
    setValue(data, forKey: Keys.countdowns.rawValue)
  }

  func loadSortingCriteria() -> SortingCriteria {
    guard let data = data(forKey: Keys.sortingCriteria.rawValue) else { return .timeLeft }
    let sortingCriteria = try? JSONDecoder().decode(SortingCriteria.self, from: data)
    return sortingCriteria ?? .timeLeft
  }

  func storeSortingCriteria(_ sortingCriteria: SortingCriteria) {
    guard let data = try? JSONEncoder().encode(sortingCriteria) else { return }
    setValue(data, forKey: Keys.sortingCriteria.rawValue)
  }
}
