//
//  CountdownRow.swift
//  CountdownRow
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import SwiftUI

struct CountdownRow: View {
  @StateObject private var viewModel = CountdownRowViewModel()
  let countdown: Countdown

  var body: some View {
    HStack {
      Text(viewModel.emoji)
        .font(.system(size: 35))

      VStack(alignment: .leading, spacing: 10) {
        if !viewModel.inThePast {
          Text(viewModel.timeRemaining)
            .font(.title2)
            .fixedSize()
            .frame(width: 100, alignment: .leading)
        }
        Text(viewModel.title)
          .fontWeight(.semibold)
      }
      .foregroundColor(viewModel.color.asColor)
    }
    .onAppear {
      viewModel.update(withCountdown: countdown)
    }
  }
}

struct CountdownRow_Previews: PreviewProvider {
  static var previews: some View {
    return CountdownRow(countdown: .futureSample)
      .previewLayout(.sizeThatFits)
      .preferredColorScheme(.dark)
  }
}
