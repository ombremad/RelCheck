//
//  Constants.swift
//  RelCheck
//
//  Created by Anne Ferret on 11/04/2026.
//

import Foundation
import SwiftData

struct Constants {
  struct Layout {
    static let cornerRadius: CGFloat = 24
  }
}

struct Preview {
  static let contact: Contact = .init(
    name: "Anne",
    daysBetweenNotifications: 7,
    icon: .bicycle,
    color: .coral,
  )

  static let contacts: [Contact] = [
    Contact(
      name: "Anne",
      daysBetweenNotifications: 3,
      icon: .bicycle,
      color: .coral,
    ),
    Contact(
      name: "Roger",
      daysBetweenNotifications: 7,
      icon: .heartFill,
      color: .honey,
    ),
    Contact(
      name: "Marcellino",
      daysBetweenNotifications: 14,
      icon: .starFill,
      color: .teal,
    ),
    Contact(
      name: "Marcel",
      daysBetweenNotifications: 14,
      icon: .starFill,
      color: .teal,
    ),
    Contact(
      name: "Marcel",
      daysBetweenNotifications: 14,
      icon: .starFill,
      color: .teal,
    ),
  ]

  struct Container {
    static let contacts: ModelContainer = {
      let container = try! ModelContainer(
        for: Contact.self,
        Settings.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true),
      )

      container.mainContext.insert(
        Contact(name: "Anne", daysBetweenNotifications: 3, icon: .bicycle, color: .coral)
      )
      container.mainContext.insert(
        Contact(name: "Roger", daysBetweenNotifications: 7, icon: .heartFill, color: .honey)
      )
      container.mainContext.insert(
        Contact(name: "Marcel", daysBetweenNotifications: 14, icon: .starFill, color: .teal)
      )

      return container
    }()

    static let settings: ModelContainer = {
      let container = try! ModelContainer(
        for: Settings.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true),
      )
      container.mainContext.insert(Settings(fastCheckIn: true, fastCheckInHour: 20, theme: .auto))

      return container
    }()

    static let empty: ModelContainer = {
      let container = try! ModelContainer(
        for: Contact.self,
        Settings.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true),
      )

      return container
    }()
  }
}
