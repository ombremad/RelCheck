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

  var showsPermissionWarning = false

  var body: some View {
    VStack(spacing: 16) {
      VStack(spacing: 16) {
        if showsPermissionWarning {
          AuthorizationWarningCard()
        }

        if contacts.isEmpty {
          EmptyStateView(reason: .contactsListEmpty)
        } else {
          Picker(selection: Binding(get: { selectedList }, set: { pickedList = $0 })) {
            ForEach([ContactsListMode.overdue, .upcoming, .recent], id: \.self) { kind in
              Text(kind.title).tag(kind)
            }
          } label: {
            EmptyView()
          }
          .pickerStyle(.segmented)

          ContactsList(contacts: contacts, mode: selectedList)
        }
      }
      .padding(.horizontal)

    }
    .background(Color(.systemGroupedBackground))
    .animation(.easeInOut, value: showsPermissionWarning)

    .navigationTitle("home.title")
    .navigationBarTitleDisplayMode(.inline)
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
