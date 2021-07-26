//
//  Date+Sub.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-06-20.
//

import Foundation

extension Date {
  static func - (lhs: Date, rhs: Date) -> TimeDifference? {
    let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: rhs, to: lhs)
    guard let years = components.year,
          let months = components.month,
          let days = components.day,
          let hours = components.hour,
          let minutes = components.minute,
          let seconds = components.second
    else {
      return nil
    }
    return TimeDifference(years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
  }
}

extension Date {
  struct TimeDifference {
    let years: Int
    let months: Int
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int

    struct Component {
      let value: Int
      let label: String
    }

    func activeComponents() -> [Component] {
      var components = [Component]()
      var shouldSelect = false

      shouldSelect = shouldSelect || (years > 0)
      if shouldSelect {
        components.append(Component(value: years, label: years == 1 ? "year" : "years"))
      }

      shouldSelect = shouldSelect || (months > 0)
      if shouldSelect {
        components.append(Component(value: months, label: months == 1 ? "month" : "months"))
      }

      shouldSelect = shouldSelect || (days > 0)
      if shouldSelect {
        components.append(Component(value: days, label: days == 1 ? "day" : "days"))
      }

      shouldSelect = shouldSelect || (hours > 0)
      if shouldSelect {
        components.append(Component(value: hours, label: hours == 1 ? "hour" : "hours"))
      }

      shouldSelect = shouldSelect || (minutes > 0)
      if shouldSelect {
        components.append(Component(value: minutes, label: minutes == 1 ? "minute" : "minutes"))
      }

      shouldSelect = shouldSelect || (seconds > 0)
      if shouldSelect {
        components.append(Component(value: seconds, label: seconds == 1 ? "second" : "seconds"))
      }

      return components
    }

    var isZero: Bool { activeComponents().isEmpty }
  }
}
