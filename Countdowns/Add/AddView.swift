//
//  AddView.swift
//  AddView
//
//  Created by Guilherme Andrade on 2021-07-25.
//

import Combine
import SwiftUI

struct AddView: View {
  @Environment(\.presentationMode) var presentationMode
  @StateObject private var viewModel = AddViewModel()

  var body: some View {
    NavigationView {
      Form {
        Section {
          emojiPicker
            .padding()
          colorPicker
            .padding([.horizontal], -10)
            .padding(.vertical, 10)
        }
        Section {
          textFields
            .padding(.vertical, 10)
        }
        Section {
          dateFields
            .padding(.vertical, 10)
          notification
            .padding(.vertical, 10)
        }
      }
      .onTapGesture { UIApplication.shared.endEditing() }
      .listStyle(InsetListStyle())
      .navigationBarTitle(Text("Details"), displayMode: .inline)
      .navigationBarItems(leading: cancelButton, trailing: doneButton)
    }
  }

  private var emojiPicker: some View {
    HStack {
      Spacer()
      EmojiSelector(emoji: $viewModel.emoji, color: viewModel.color.asColor, size: 85)
      Spacer()
    }
  }

  private var textFields: some View {
    VStack {
      TextField("Title", text: $viewModel.name)
        .font(.title2.bold())
        .padding(.bottom, 10)
      TextField("Notes", text: $viewModel.notes)
        .font(.body)
    }
  }

  private var colorPicker: some View {
    HStack {
      Spacer()
      ColorPicker(selected: $viewModel.color, size: 45)
      Spacer()
    }
  }

  private var dateFields: some View {
    VStack {
      DatePicker("Date",
                 selection: $viewModel.targetDate,
                 in: Date()...,
                 displayedComponents: [.date])
        .datePickerStyle(CompactDatePickerStyle())

      VStack(spacing: 0) {
        Toggle("Time", isOn: $viewModel.showingTimeSelection)
        if viewModel.showingTimeSelection {
          DatePicker(selection: $viewModel.targetTime,
                     in: Date()...,
                     displayedComponents: [.hourAndMinute], label: {})
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .frame(alignment: .center)
            .animation(.linear, value: viewModel.showingTimeSelection)
        }
      }
    }
  }

  private var notification: some View {
    VStack(alignment: .center) {
      Toggle("Reminder", isOn: $viewModel.isReminderOn)
        .onChange(of: viewModel.isReminderOn) { newValue in
          if newValue, !viewModel.hasNotificationPermission {
            viewModel.askNotificationPermission()
          }
        }
      if viewModel.isReminderOn && viewModel.hasNotificationPermission {
        MultiPicker(options: Reminder.allCases.map(\.rawValue), selectedOptions: $viewModel.reminders)
      }
    }
  }

  private var cancelButton: some View {
    Button("Cancel") {
      presentationMode.wrappedValue.dismiss()
    }
  }

  private var doneButton: some View {
    Button("Done") {
      addNewCountdown()
      presentationMode.wrappedValue.dismiss()
    }
    .disabled(viewModel.name == "")
  }

  private func addNewCountdown() {
    viewModel.addCountdown()
  }
}

struct AddCountdownView_Previews: PreviewProvider {
  static var previews: some View {
    AddView()
      .preferredColorScheme(.dark)
  }
}

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
