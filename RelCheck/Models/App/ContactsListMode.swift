//
//  ContactsListMode.swift
//  RelCheck
//
//  Created by Anne Ferret on 09/10/2026.
//

import SwiftUI

enum ContactsListMode: CaseIterable {
  case regular, overdue, upcoming, recent

  var title: LocalizedStringKey {
    switch self {
    case .regular: "contacts.title"
    case .overdue: "home.overdue.title"
    case .upcoming: "home.upcoming.title"
    case .recent: "home.recent.title"
    }
  }

  var emptyReason: ContentUnavailableReason {
    switch self {
    case .regular, .upcoming: .contactsListEmpty
    case .overdue: .noOverdueContact
    case .recent: .noRecentCheckIn
    }
  }

  func contacts(from contacts: [Contact]) -> [Contact] {
    switch self {
    case .regular:
      // sorted by alphabetical order
      contacts.sorted { contact1, contact2 in
        contact1.name < contact2.name
      }
    case .overdue:
      // filtered by overdue only
      // sorted by most late
      contacts
        .filter { $0.nextUpcomingNotification == nil }
        .sorted { contact1, contact2 in
          switch (contact1.overdueNotification?.date, contact2.overdueNotification?.date) {
          case (nil, nil): return contact1.name < contact2.name
          case (nil, _): return true
          case (_, nil): return false
          case (let d1?, let d2?): return d1 < d2
          }
        }
    case .upcoming:
      // sorted by closest next upcoming notification
      contacts
        .compactMap { contact in contact.nextUpcomingNotification.map { (contact, $0.date) } }
        .sorted { $0.1 < $1.1 }
        .map(\.0)
    case .recent:
      // sorted by most recently checked in
      contacts
        .compactMap { contact in contact.lastCheckIn.map { (contact, $0.date) } }
        .sorted { $0.1 > $1.1 }
        .map(\.0)
    }
  }
}
