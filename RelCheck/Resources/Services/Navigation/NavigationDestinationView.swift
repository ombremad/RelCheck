//
//  NavigationDestinationView.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftData
import SwiftUI

struct NavigationDestinationView: View {
  let destination: AppDestination

  var body: some View {
    switch destination {
    case .about: AboutView()
    case .contactList: ContactsView()
    case .debug: DebugView()
    case .fastCheckIn: FastCheckInView()
    case .home: HomeView()
    case .newContact: ContactFormView()
    case .settings: SettingsView()
    case .contact(let id):
      ContactResolver(id: id) { SingleContactView(contact: $0) }
    case .editContact(let id):
      ContactResolver(id: id) { ContactFormView(contact: $0) }
    }
  }
}

private struct ContactResolver<Content: View>: View {
  @Query private var matches: [Contact]
  private let content: (Contact) -> Content

  init(id: UUID, @ViewBuilder content: @escaping (Contact) -> Content) {
    _matches = Query(filter: #Predicate<Contact> { $0.id == id })
    self.content = content
  }

  var body: some View {
    if let contact = matches.first {
      content(contact)
    } else {
      EmptyStateView(reason: .contactNotFound)
    }
  }
}
