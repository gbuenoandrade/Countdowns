//
//  MultiPicker.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-07-11.
//

import SwiftUI

struct MultiPicker: View {
  let options: [String]
  @Binding var selectedOptions: Set<String>

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {
      ForEach(options, id: \.self) { option in
        HStack {
          Image(systemName: "checkmark")
            .opacity(selectedOptions.contains(option) ? 1 : 0)
          Text(option)
        }
        .onTapGesture { toggleOption(option) }
      }
      .listStyle(InsetListStyle())
    }
  }

  private func toggleOption(_ option: String) {
    if selectedOptions.contains(option) {
      selectedOptions.remove(option)
    } else {
      selectedOptions.insert(option)
    }
  }
}

struct MultiPicker_Previews: PreviewProvider {
  @State static var options: Set<String> = []

  static var previews: some View {
    let options = Reminder.allCases.map(\.rawValue)
    MultiPicker(options: options, selectedOptions: $options)
  }
}
