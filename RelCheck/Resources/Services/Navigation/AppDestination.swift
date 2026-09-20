//
//  AppDestination.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import Foundation

enum AppDestination: Hashable, Codable {
  case about
  case contacts
  case fastCheckIn
  case newContact
  case settings
  case singleContact(id: UUID)
  case editContact(id: UUID)
}
