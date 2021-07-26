//
//  AddViewModel.swift
//  AddViewModel
//
//  Created by Guilherme Andrade on 2021-07-25.
//

import Foundation

import Combine
import Foundation

class AddViewModel: ObservableObject {
  @Published var showingTimeSelection = false
  @Published var emoji = "🚀"
  @Published var color: PastelColor = .red
  @Published var name = ""
  @Published var notes = ""
  @Published var targetDate = Date()
  @Published var targetTime = Date()
  @Published var isReminderOn = false
  @Published var reminders: Set<String> = []
  @Published var hasNotificationPermission = false

  private var cancellables: Set<AnyCancellable> = []
  private let dataService = CountdownService.shared

  func askNotificationPermission() {
    NotificationScheduler.shared.askPermissions()
      .first()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] hasPermission in
        self?.hasNotificationPermission = hasPermission
      }
      .store(in: &cancellables)
  }

  func addCountdown() {
    guard let target = mergedDate() else {
      return
    }
    let countdownToAdd = Countdown(
      title: name,
      target: target,
      emoji: emoji,
      notes: notes,
      color: color
    )
    if isReminderOn {
      NotificationScheduler.shared.schedule(reminders.compactMap { Reminder(rawValue: $0) }, for: countdownToAdd)
    }
    dataService.addCountdown(countdownToAdd)
  }

  private func mergedDate() -> Date? {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.day, .month, .year], from: targetDate)
    let timeComponents = calendar.dateComponents([.hour, .minute], from: targetTime)
    let mergedComponents = DateComponents(
      year: dateComponents.year,
      month: dateComponents.month,
      day: dateComponents.day,
      hour: showingTimeSelection ? timeComponents.hour : 0,
      minute: showingTimeSelection ? timeComponents.minute : 0
    )
    return calendar.date(from: mergedComponents)
  }
}
