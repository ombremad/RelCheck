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
    static let heroIconSize: CGFloat = 64
    static let labelIconWidth: CGFloat = 24
    static let compactLabelIconWidth: CGFloat = 8
    static let pickerGridMinimum: CGFloat = 60
    static let pickerGridSpacing: CGFloat = 12
  }

  struct Contacts {
    static let defaultDaysBetweenNotifications = 7
    static let checkInFrequencyRange = 1...90
  }

  struct FastCheckIn {
    static let defaultHour = 20
  }

  struct Time {
    static let secondsInDay: TimeInterval = 86_400
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
