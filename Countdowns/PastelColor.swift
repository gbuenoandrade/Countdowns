//
//  PastelColor.swift
//  PastelColor
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import Foundation
import SwiftUI

enum PastelColor: String, CaseIterable, Codable {
  case red
  case orange
  case yello
  case green
  case lightBlue
  case darkBlue
  case purple
  case magenta
  case pink
  case brown
  case gray
  case salmon

  var asColor: Color {
    switch self {
    case .red:
      return Color(red: 253 / 255.0, green: 69 / 255.0, blue: 57 / 255.0)
    case .orange:
      return Color(red: 254 / 255.0, green: 160 / 255.0, blue: 10 / 255.0)
    case .yello:
      return Color(red: 255 / 255.0, green: 212 / 255.0, blue: 9 / 255.0)
    case .green:
      return Color(red: 50 / 255.0, green: 209 / 255.0, blue: 91 / 255.0)
    case .lightBlue:
      return Color(red: 120 / 255.0, green: 196 / 255.0, blue: 254 / 255.0)
    case .darkBlue:
      return Color(red: 5 / 255.0, green: 136 / 255.0, blue: 252 / 255.0)
    case .purple:
      return Color(red: 93 / 255.0, green: 92 / 255.0, blue: 230 / 255.0)
    case .magenta:
      return Color(red: 254 / 255.0, green: 79 / 255.0, blue: 120 / 255.0)
    case .pink:
      return Color(red: 212 / 255.0, green: 127 / 255.0, blue: 246 / 255.0)
    case .brown:
      return Color(red: 201 / 255.0, green: 165 / 255.0, blue: 115 / 255.0)
    case .gray:
      return Color(red: 114 / 255.0, green: 124 / 255.0, blue: 134 / 255.0)
    case .salmon:
      return Color(red: 234 / 255.0, green: 181 / 255.0, blue: 173 / 255.0)
    }
  }
}
