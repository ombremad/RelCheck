//
//  ContactsView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import SwiftData

struct ContactsView: View {
  @Environment(AppNavigator.self) private var navigator

  @Query(sort: \Contact.name) private var contacts: [Contact]

  var body: some View {
    ContactsList(contacts: contacts)
      .navigationTitle("contacts.title")
      .navigationBarTitleDisplayMode(.inline)

      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button {
            navigator.push(.newContact)
          } label: {
            Label("button.addContact", systemImage: "person.badge.plus")
          }
        }
      }
  }
}

#Preview("Contacts") {
  ContactsView()
    .modelContainer(Preview.Container.contacts)
    .environment(AppNavigator())
}

#Preview("Without contacts") {
  ContactsView()
    .modelContainer(Preview.Container.empty)
    .environment(AppNavigator())
}
