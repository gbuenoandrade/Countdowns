//
//  CountdownRowViewModel.swift
//  CountdownRowViewModel
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Combine
import Foundation

class CountdownRowViewModel: ObservableObject {
  @Published private(set) var timeRemaining: String = ""
  @Published private(set) var title = "My birthday"
  @Published private(set) var emoji = "🥳"
  @Published private(set) var color: PastelColor = .pink
  @Published private(set) var inThePast = true

  private var cancellables: Set<AnyCancellable> = []

  private let formatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.dateTimeStyle = .numeric
    return formatter
  }()

  func update(withCountdown countdown: Countdown) {
    title = countdown.title
    emoji = countdown.emoji
    color = countdown.color
    inThePast = countdown.inThePast

    cancellables.removeAll()

    [Date()].publisher.append(TimeSource.shared)
      .compactMap { [weak self] now in
        self?.formatter
          .localizedString(for: countdown.target, relativeTo: now)
          .lowercased()
      }
      .map {
        $0.hasPrefix("in ") ? String($0.dropFirst(3)) : $0
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.timeRemaining, on: self)
      .store(in: &cancellables)
    TimeSource.shared
      .compactMap { countdown.target < $0 }
      .removeDuplicates()
      .dropFirst()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] inThePast in
        guard let self = self else { return }
        self.inThePast = inThePast
        NotificationCenter.default.post(name: .countdownDidChangeExpirationStatus, object: nil)
      }
      .store(in: &cancellables)
  }
}

extension Notification.Name {
  static let countdownDidChangeExpirationStatus = Notification.Name("countdownDidChangeExpirationStatus")
}
