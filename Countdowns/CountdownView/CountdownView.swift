//
//  CountdownView.swift
//  CountdownView
//
//  Created by Guilherme Andrade on 2021-07-25.
//

import SwiftUI

struct CountdownView: View {
  @StateObject private var viewModel = CountdownViewModel()

  let countdown: Countdown

  var body: some View {
    VStack {
      Text(viewModel.emoji)
        .font(.system(size: 60))
      Text(viewModel.title)
        .font(.title3.bold())
        .foregroundColor(viewModel.color.asColor)
      timeSection
      Text(viewModel.notes)
    }
    .padding()
    .onAppear {
      viewModel.update(countdown: countdown)
    }
  }

  private var timeSection: some View {
    ZStack {
      TimerView(countdown: countdown)
      VStack {
        if let timeRemaining = viewModel.timeRemaining {
          Text(timeRemaining)
            .font(.title2)
            .padding()
          Text(viewModel.targetLabel)
            .font(.caption)
        } else {
          Text(viewModel.targetLabel)
            .font(.title3)
        }
      }
    }
  }
}

struct CountdownView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownView(countdown: .futureSample)
      .preferredColorScheme(.dark)
  }
}
