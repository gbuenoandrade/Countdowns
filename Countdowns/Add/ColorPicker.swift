//
//  ColorPicker.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-07-10.
//

import SwiftUI

struct ColorPicker: View {
  @Binding var selected: PastelColor

  private let size: CGFloat
  private let rows: [GridItem]

  init(selected: Binding<PastelColor>, size: CGFloat = 50) {
    _selected = selected
    self.size = size
    rows = [GridItem(.fixed(size)), GridItem(.fixed(size))]
  }

  var body: some View {
    VStack {
      LazyHGrid(rows: rows, spacing: 8) {
        ForEach(PastelColor.allCases, id: \.self) { color in
          ColorOption(selected: $selected, option: color, size: size)
        }
      }
    }
  }
}

struct ColorOption: View {
  @Binding var selected: PastelColor

  let option: PastelColor
  let size: CGFloat

  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.primary, lineWidth: 1.4)
        .frame(width: size * 1.1, height: size * 1.1)
        .opacity(selected == option ? 0.8 : 0)

      Circle()
        .frame(width: size, height: size)
        .foregroundColor(option.asColor)
        .onTapGesture {
          selected = option
        }
    }
  }
}

struct ColorPicker_Previews: PreviewProvider {
  @State static var color: PastelColor = .orange

  static var previews: some View {
    ColorPicker(selected: $color)
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}
