//
//  Countdown.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Foundation

struct Countdown: Codable, Identifiable, Hashable {
  let id: UUID
  let title: String
  let target: Date
  let emoji: String
  let notes: String
  let color: PastelColor
  let createdAt: Date

  init(id: UUID = UUID(), title: String, target: Date, emoji: String, notes: String, color: PastelColor, createdAt: Date = Date()) {
    self.id = id
    self.title = title
    self.target = target
    self.emoji = emoji
    self.notes = notes
    self.color = color
    self.createdAt = createdAt
  }

  var inThePast: Bool {
    target < Date()
  }
}

extension Countdown {
  static let futureSample = Countdown(
    title: "My birthday",
    target: Date().addingTimeInterval(60 * 60 * 24),
    emoji: "🥳",
    notes: "Mauris non scelerisque ante. Nullam libero nisi, finibus a risus malesuada, faucibus consequat lorem. Fusce quis pulvinar ante. Donec urna tellus, vulputate sit amet faucibus ullamcorper, vehicula vel felis. Nam quis ex arcu. Sed porta viverra mi, et vulputate urna efficitur a. Fusce posuere blandit massa nec gravida",
    color: .lightBlue
  )

  static let pastSample = Countdown(
    title: "Christmas",
    target: Date().addingTimeInterval(-200),
    emoji: "🎄",
    notes: "Mauris non scelerisque ante. Nullam libero nisi, finibus a risus malesuada, faucibus consequat lorem. Fusce quis pulvinar ante. Donec urna tellus, vulputate sit amet faucibus ullamcorper, vehicula vel felis. Nam quis ex arcu. Sed porta viverra mi, et vulputate urna efficitur a. Fusce posuere blandit massa nec gravida",
    color: .red
  )
}
