//
//  Publisher+Timer.swift
//  Publisher+Timer
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Combine
import Foundation

struct TimeSource {
  static let shared =
    Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .share()
      .eraseToAnyPublisher()
}
