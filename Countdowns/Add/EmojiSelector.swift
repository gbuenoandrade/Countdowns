//
//  EmojiSelector.swift
//  Countdown
//
//  Created by Guilherme Andrade on 2021-07-10.
//

import SwiftUI

struct EmojiSelector: View {
  @Binding var emoji: String

  let color: Color
  let size: CGFloat

  var body: some View {
    ZStack {
      Circle()
        .frame(width: size, height: size)
        .foregroundColor(color)

      TextFieldWrapperView(text: $emoji, size: size * 0.65)
        .fixedSize()
    }
  }
}

struct TextFieldWrapperView: UIViewRepresentable {
  @Binding var text: String
  let size: CGFloat

  func makeCoordinator() -> TFCoordinator { TFCoordinator(self) }
}

class TFCoordinator: NSObject, UITextFieldDelegate {
  var parent: TextFieldWrapperView

  init(_ textField: TextFieldWrapperView) {
    parent = textField
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
    guard string.isSingleEmoji else { return false }
    textField.text = ""
    parent.text = string
    return true
  }
}

extension TextFieldWrapperView {
  func makeUIView(context: UIViewRepresentableContext<TextFieldWrapperView>) -> UITextField {
    let textField = EmojiTextField()
    textField.text = context.coordinator.parent.text
    textField.delegate = context.coordinator
    textField.font = .systemFont(ofSize: context.coordinator.parent.size)
    return textField
  }

  func updateUIView(_: UITextField, context _: Context) {}
}

class EmojiTextField: UITextField {
  // required for iOS 13
  override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

  override var textInputMode: UITextInputMode? {
    for mode in UITextInputMode.activeInputModes {
      if mode.primaryLanguage == "emoji" {
        return mode
      }
    }
    return nil
  }
}

struct EmojiSelector_Previews: PreviewProvider {
  static var previews: some View {
    EmojiSelector(emoji: .constant("🙌"), color: .red, size: 75)
      .preferredColorScheme(.dark)
      .previewLayout(.sizeThatFits)
  }
}

extension Character {
  var isSimpleEmoji: Bool {
    guard let firstScalar = unicodeScalars.first else { return false }
    return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
  }

  var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

  var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
  var isSingleEmoji: Bool { count == 1 && containsEmoji }

  var containsEmoji: Bool { contains { $0.isEmoji } }
}
