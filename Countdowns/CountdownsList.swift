//
//  CountdownsList.swift
//  Countdowns
//
//  Created by Guilherme Andrade on 2021-07-24.
//

import SwiftUI

struct CountdownsList: View {
  @StateObject private var viewModel = CountdownsListViewModel()
  @State private var showingAddSheet = false
  @State private var showingSortOptions = false

  var body: some View {
    NavigationView {
      VStack {
        List {
          futureSection
          if !viewModel.pastCountdowns.isEmpty {
            pastSection
          }
        }
        .listStyle(InsetListStyle())
        addButtom
      }
      .navigationTitle("Countdowns")
      .navigationBarItems(trailing: sortingPicker)
      .sheet(isPresented: $showingAddSheet) {
        AddView()
      }
    }
  }

  private var futureSection: some View {
    Section {
      ForEach(viewModel.futureCountdowns) { countdown in
        NavigationLink(destination: CountdownView(countdown: countdown)) {
          CountdownRow(countdown: countdown)
        }
      }
      .onDelete(perform: viewModel.removeFutureCountdowns(at:))
    }
  }

  private var pastSection: some View {
    Section(header: Text("Past")) {
      ForEach(viewModel.pastCountdowns) { countdown in
        NavigationLink(destination: CountdownView(countdown: countdown)) {
          CountdownRow(countdown: countdown)
            .opacity(0.8)
        }
      }
      .onDelete(perform: viewModel.removePastCountdowns(at:))
    }
  }

  private var addButtom: some View {
    HStack {
      Spacer()
      Button(action: { showingAddSheet.toggle() }) {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 30)
      }
      .padding(.horizontal, 30)
      .padding(.vertical, 10)
    }
  }

  private var sortingPicker: some View {
    let selection = Binding(
      get: { viewModel.sortingCriteria },
      set: { viewModel.sortingCriteria = $0 }
    )
    return Picker(selection: selection, label:
      Image(systemName: "ellipsis.circle")
        .resizable()
        .scaledToFit()
        .frame(width: 20)) {
        Text("Time left").tag(SortingCriteria.timeLeft)
        Text("Creation").tag(SortingCriteria.creation)
    }
    .pickerStyle(MenuPickerStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    CountdownsList()
  }
}
