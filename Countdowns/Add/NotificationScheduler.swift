//
//  NotificationScheduler.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-07-11.
//

import Combine
import Foundation
import UserNotifications

enum Reminder: String, CaseIterable {
  case fiveMin = "5 minutes before"
  case thirtyMin = "30 minutes before"
  case oneHour = "1 hour before"
  case oneDay = "1 day before"
}

class NotificationScheduler {
  static let shared = NotificationScheduler()

  func schedule(_ reminders: [Reminder], for countdown: Countdown) {
    let now = Date().timeIntervalSince1970
    for reminder in reminders {
      var diff = countdown.target.timeIntervalSince1970 - now
      let suffix: String
      switch reminder {
      case .fiveMin:
        diff -= 5 * 60
        suffix = "in 5 minutes!"
      case .thirtyMin:
        diff -= 30 * 60
        suffix = "in 30 minutes!"
      case .oneHour:
        diff -= 60 * 60
        suffix = "in 1 hour!"
      case .oneDay:
        diff -= 24 * 60 * 60
        suffix = "in 1 day!"
      }
      guard diff > 0 else { continue }
      let content = UNMutableNotificationContent()
      content.title = "Countdowns"
      content.subtitle = "\(countdown.title) \(suffix)"
      content.sound = UNNotificationSound.default
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: diff, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request)
    }
  }

  func askPermissions() -> AnyPublisher<Bool, Never> {
    let subject = PassthroughSubject<Bool, Never>()
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
      if success {
        subject.send(true)
      } else if let error = error {
        print("Failed getting notification: \(error)")
        subject.send(false)
      }
      subject.send(completion: .finished)
    }
    return subject.eraseToAnyPublisher()
  }
}
