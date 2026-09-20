//
//  ContactsView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import SwiftData

struct ContactsView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppNavigator.self) private var navigator

  @Query private var settingsArray: [Settings]
  @Query(sort: \Contact.name) private var contacts: [Contact]

  // Computed properties
  private var settings: Settings {
    if let existing = settingsArray.first { return existing }
    let newSettings = Settings()
    modelContext.insert(newSettings)
    return newSettings
  }

  private var sortedContacts: [Contact] {
    contacts.sorted { contact1, contact2 in
      let date1 = contact1.nextUpcomingNotification?.date
      let date2 = contact2.nextUpcomingNotification?.date

      switch (date1, date2) {
      case (nil, nil): return contact1.name < contact2.name
      case (nil, _): return true
      case (_, nil): return false
      case (let d1?, let d2?): return d1 < d2
      }
    }
  }

  var body: some View {
    List {

      if contacts.isEmpty {
        ContentUnavailableView {
          Label("contacts.contentUnavailableTitle", systemImage: "questionmark.app.fill")
        } description: {
          Text("contacts.contentUnavailableCTA")
        } actions: {
          Button("button.addContact") {
            navigator.navigate(to: .newContact)
          }.buttonStyle(.borderedProminent)
        }
      }

      ForEach(sortedContacts) { contact in
        ContactRow(contact: contact).swipeActions {
          Button(role: .destructive) {
            deleteContact(contact)
          } label: {
            Label("button.delete", systemImage: "trash")
          }
        }
      }
    }

    .navigationTitle("contacts.title")
    .navigationBarTitleDisplayMode(.inline)
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          navigator.navigate(to: .newContact)
        } label: {
          Label("button.addContact", systemImage: "person.badge.plus")
        }
      }
    }
  }

  private func deleteContact(_ contact: Contact) {
    contact.delete(from: modelContext)
  }
}

#Preview("With contacts") {
  let container = try! ModelContainer(
    for: Contact.self, Settings.self, configurations: .init(isStoredInMemoryOnly: true))

  container.mainContext.insert(
    Contact(
      name: "Anne",
      daysBetweenNotifications: 3,
      icon: .bicycle,
      color: .coral,
    ))
  container.mainContext.insert(
    Contact(
      name: "Roger",
      daysBetweenNotifications: 7,
      icon: .heartFill,
      color: .honey,
    ))
  container.mainContext.insert(
    Contact(
      name: "Marcel",
      daysBetweenNotifications: 14,
      icon: .starFill,
      color: .teal,
    ))

  return ContactsView().modelContainer(container).environment(AppNavigator())
}

#Preview("Without contacts") {
  let container = try! ModelContainer(
    for: Contact.self, Settings.self, configurations: .init(isStoredInMemoryOnly: true))

  ContactsView().modelContainer(container).environment(AppNavigator())
}
