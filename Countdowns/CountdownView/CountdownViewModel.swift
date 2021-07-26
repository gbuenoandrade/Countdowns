//
//  CountdownViewModel.swift
//  CountdownViewModel
//
//  Created by Guilherme Andrade on 2021-07-25.
//

import Combine
import Foundation

class CountdownViewModel: ObservableObject {
  @Published private(set) var timeRemaining: String? = ""
  @Published private(set) var title = ""
  @Published private(set) var emoji = "🚀"
  @Published private(set) var notes = ""
  @Published private(set) var targetLabel = ""
  @Published private(set) var color: PastelColor = .red

  private var cancellable: Cancellable?
  private var target = Date()

  private var targetFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd, yyyy @ HH:mm a"
    return formatter
  }()

  func update(countdown: Countdown) {
    title = countdown.title
    emoji = countdown.emoji
    notes = countdown.notes
    target = countdown.target
    color = countdown.color
    targetLabel = targetFormatter.string(from: target)

    cancellable = Just(Date()).append(TimeSource.shared)
      .sink { [weak self] in self?.updateTimeRemaining(now: $0) }
  }

  func updateTimeRemaining(now: Date) {
    guard let diff = target - now else { return }
    guard !diff.isZero else {
      timeRemaining = nil
      return
    }
    let allComponents = diff.activeComponents()
    let componentsToDrop = max(0, allComponents.count - 3)
    let components = allComponents.dropLast(componentsToDrop)
    timeRemaining = components
      .map { "\($0.value) \($0.label)" }
      .joined(separator: " ")
  }
}
