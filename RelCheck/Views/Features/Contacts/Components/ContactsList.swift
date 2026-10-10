//
//  ContactsList.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/10/2026.
//

import SwiftUI
import SwiftData

struct ContactsList: View {
  @Environment(\.modelContext) private var modelContext

  let contacts: [Contact]
  var mode: ContactsListMode = .regular

  private var shownContacts: [Contact] {
    mode.contacts(from: contacts)
  }

  var body: some View {
    List {
      if shownContacts.isEmpty {
        EmptyStateView(reason: mode.emptyReason)
      } else if mode == .regular {
        Section { rows }
      } else {
        Section {
          rows
        } header: {
          header
        }
      }
    }
    .listStyle(.insetGrouped)
  }

  @ViewBuilder
  private var rows: some View {
    ForEach(shownContacts) { contact in
      ContactRow(contact: contact, mode: mode)
        .swipeActions {
          if mode == .regular {
            Button(role: .destructive) {
              deleteContact(contact)
            } label: {
              Label("button.delete", systemImage: "trash")
            }
          }
        }
    }
  }

  @ViewBuilder
  private var header: some View {
    HStack(alignment: .center) {
      Image(systemName: mode.icon)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 20, height: 20)
        .accessibilityHidden(true)
      Text(mode.subtitle)
        .font(.callout)
        .lineLimit(1)
        .allowsTightening(true)
      Spacer()
    }
    .foregroundStyle(.secondary)
  }

  private func deleteContact(_ contact: Contact) {
    contact.delete(from: modelContext)
  }
}

#Preview("Regular") {
  ContactsList(contacts: Preview.contacts)
    .environment(AppNavigator())
}

#Preview("Overdue") {
  ContactsList(contacts: Preview.contacts, mode: .overdue)
    .modelContainer(Preview.Container.contacts)
    .environment(AppNavigator())
}

#Preview("Upcoming") {
  ContactsList(contacts: Preview.contacts, mode: .upcoming)
    .modelContainer(Preview.Container.contacts)
    .environment(AppNavigator())
}

#Preview("History") {
  ContactsList(contacts: Preview.contacts, mode: .recent)
    .modelContainer(Preview.Container.contacts)
    .environment(AppNavigator())
}

#Preview("Without contacts") {
  ContactsList(contacts: [])
    .environment(AppNavigator())
}
