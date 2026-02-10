//
//  AppDestination.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import Foundation

enum AppDestination: Hashable {
    case about
    case editContact(contact: Contact)
    case fastCheckIn
    case newContact
    case settings
    case singleContact(id: String)
}
