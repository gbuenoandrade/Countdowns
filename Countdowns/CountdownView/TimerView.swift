//
//  TimerView.swift
//  TimerView
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Combine
import SwiftUI

struct TimerView: View {
  @StateObject private var viewModel = TimerViewModel()
  let countdown: Countdown

  var body: some View {
    ZStack {
      Arc(angle: .degrees(360))
        .foregroundColor(.primary)
        .opacity(0.13)
      Arc(angle: viewModel.remainingAngle)
        .foregroundColor(viewModel.color)
    }
    .onAppear {
      viewModel.update(from: countdown.createdAt, to: countdown.target, color: countdown.color.asColor)
    }
  }
}

class TimerViewModel: ObservableObject {
  @Published var remainingAngle: Angle = .zero
  @Published var color: Color = .black

  private var from = Date()
  private var to = Date()
  private var cancellable: Cancellable?

  private let timer = TimeSource.shared

  func update(from: Date, to: Date, color: Color) {
    self.from = from
    self.to = to
    self.color = color
    cancellable = Just(Date()).append(timer)
      .map { now -> Angle in
        guard now < self.to else {
          return .zero
        }
        let remaining = self.to.timeIntervalSince1970 - now.timeIntervalSince1970
        let total = self.to.timeIntervalSince1970 - self.from.timeIntervalSince1970
        return Angle(degrees: remaining / total * 360)
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.remainingAngle, on: self)
  }
}

struct Arc: Shape {
  let angle: Angle
  func path(in rect: CGRect) -> Path {
    var p = Path()
    let radius = min(rect.width, rect.height) / 2 * 0.9
    p.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: .degrees(270), endAngle: .degrees(270) + angle, clockwise: false)
    return p.strokedPath(.init(lineWidth: 8.0, lineCap: .round))
  }
}

struct TimerView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView(countdown: .futureSample)
  }
}
