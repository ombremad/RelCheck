//
//  AppDestination.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import Foundation

enum AppDestination: Hashable, Codable {
  case about
  case contact
  case contactList
  case editContact(id: UUID)
  case debug
  case fastCheckIn
  case newContact
  case settings
}
