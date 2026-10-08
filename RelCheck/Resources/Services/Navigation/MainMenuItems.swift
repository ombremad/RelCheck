//
//  MainMenuItems.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/10/2026.
//

import SwiftUI

extension AppDestination {
  static let mainMenuItems: [AppDestination] = [
    .home, .contactList, .fastCheckIn, .settings,
  ]

  var menuTitle: LocalizedStringKey {
    switch self {
    case .contactList: "contacts.title"
    case .fastCheckIn: "fastCheckIn.title"
    case .settings: "settings.title"
    default: "home.title"
    }
  }

  var menuIcon: String {
    switch self {
    case .contactList: "person.2"
    case .fastCheckIn: "hare"
    case .settings: "gear"
    default: "house"
    }
  }
}
