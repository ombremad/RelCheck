//
//  ContentUnavailableReason.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/10/2026.
//

import SwiftUI

enum ContentUnavailableReason {
  case contactsListEmpty, noOverdueContact, noRecentCheckIn, contactNotFound

  struct CTA {
    let label: LocalizedStringKey
    let action: (AppNavigator) -> Void
  }

  var title: LocalizedStringKey {
    switch self {
    case .contactsListEmpty: "contentUnavailable.contactsListEmpty.title"
    case .noOverdueContact: "contentUnavailable.noOverdueContact.title"
    case .noRecentCheckIn: "contentUnavailable.noRecentCheckIn.title"
    case .contactNotFound: "contentUnavailable.contactNotFound.title"
    }
  }

  var description: LocalizedStringKey {
    switch self {
    case .contactsListEmpty: "contentUnavailable.contactsListEmpty.description"
    case .noOverdueContact: "contentUnavailable.noOverdueContact.description"
    case .noRecentCheckIn: "contentUnavailable.noRecentCheckIn.description"
    case .contactNotFound: "contentUnavailable.contactNotFound.description"
    }
  }

  var systemImage: String {
    switch self {
    case .contactsListEmpty: "questionmark.app.fill"
    case .noOverdueContact: "party.popper"
    case .noRecentCheckIn: "clock"
    case .contactNotFound: "person.crop.circle.badge.questionmark"
    }
  }

  var cta: CTA? {
    switch self {
    case .contactsListEmpty: CTA(label: "button.addContact") { $0.push(.newContact) }
    default: nil
    }
  }
}
