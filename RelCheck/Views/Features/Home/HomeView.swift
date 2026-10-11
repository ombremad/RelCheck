//
//  HomeView.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Query(sort: \Contact.name) private var contacts: [Contact]

  @State private var pickedList: ContactsListMode?
  private var selectedList: ContactsListMode {
    pickedList
      ?? (ContactsListMode.overdue.contacts(from: contacts).isEmpty
        ? .upcoming
        : .overdue)
  }

  var body: some View {
    VStack(spacing: 0) {
      AuthorizationWarningCard()
        .padding(.horizontal)

      if contacts.isEmpty {
        EmptyStateView(reason: .contactsListEmpty)
      } else {
        ContactsList(contacts: contacts, mode: selectedList)
          .scrollContentBackground(.hidden)
      }
    }
    .background(LinearGradient.subtleBackground(selectedList.backgroundColor))

    .navigationTitle("home.title")
    .navigationBarTitleDisplayMode(.inline)

    .toolbar {
      if !contacts.isEmpty {
        ToolbarItem(placement: .principal) {
          Picker(
            "home.mode.title",
            selection: Binding(
              get: { selectedList },
              set: { newMode in
                pickedList = newMode
              },
            ),
          ) {
            ForEach([ContactsListMode.overdue, .upcoming, .recent], id: \.self) { mode in
              Text(mode.title).tag(mode)
            }
          }
          .pickerStyle(.segmented)
        }
      }
    }
  }
}

#Preview("Regular", traits: .portrait) {
  NavigationStack {
    HomeView()
      .modelContainer(Preview.Container.contacts)
      .environment(AppNavigator())
  }
}

#Preview("Compact", traits: .landscapeRight) {
  NavigationStack {
    HomeView()
      .modelContainer(Preview.Container.contacts)
      .environment(AppNavigator())
  }
}
