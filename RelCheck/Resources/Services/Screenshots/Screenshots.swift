//
//  Screenshots.swift
//  RelCheck
//
//  Created by Anne Ferret on 11/10/2026.
//

import Foundation
import SwiftData

#if DEBUG
  struct Screenshots {
    static var isEnabled: Bool { ProcessInfo.processInfo.arguments.contains("-screenshots") }

    struct SeedContact {
      let name: String
      let days: Int  // daysBetweenNotifications
      let icon: ContactIcon
      let color: ContactColor
      let checkInsDaysAgo: [Int]
      let dueInDays: Int  // negative = overdue
    }

    static let contacts: [SeedContact] = [
      SeedContact(
        name: "Emma",
        days: 2,
        icon: .crownFill,
        color: .rose,
        checkInsDaysAgo: [1, 3, 5, 7],
        dueInDays: 2,
      ),
      SeedContact(
        name: "Arthur",
        days: 90,
        icon: .handThumbsdownFill,
        color: .copper,
        checkInsDaysAgo: [30, 90],
        dueInDays: -10,
      ),
      SeedContact(
        name: "Anne",
        days: 7,
        icon: .bicycle,
        color: .ruby,
        checkInsDaysAgo: [2, 7, 12],
        dueInDays: 4,
      ),
      SeedContact(
        name: "Elsa",
        days: 30,
        icon: .snowflake,
        color: .sky,
        checkInsDaysAgo: [12],
        dueInDays: 29,
      ),
      SeedContact(
        name: "Leaf",
        days: 50,
        icon: .leafFill,
        color: .sage,
        checkInsDaysAgo: [],
        dueInDays: 50,
      ),
      SeedContact(
        name: "Elliot",
        days: 42,
        icon: .infinitySymbol,
        color: .honey,
        checkInsDaysAgo: [42, 42],
        dueInDays: 1,
      ),
      SeedContact(
        name: "John",
        days: 15,
        icon: .personFill,
        color: .gray,
        checkInsDaysAgo: [3, 8, 12],
        dueInDays: -6,
      ),
    ]

    static func makeContainer() throws -> ModelContainer {
      let container = try ModelContainer(
        for: CheckIn.self,
        Contact.self,
        Notification.self,
        Settings.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none),
      )
      seed(container.mainContext)
      return container
    }

    private static func seed(_ context: ModelContext) {
      let day = Constants.Time.secondsInDay
      for seed in contacts {
        let contact = Contact(name: seed.name, daysBetweenNotifications: seed.days, icon: seed.icon, color: seed.color)
        context.insert(contact)
        for daysAgo in seed.checkInsDaysAgo {
          context.insert(CheckIn(date: .now.addingTimeInterval(-Double(daysAgo) * day), contact: contact))
        }
        context.insert(Notification(date: .now.addingTimeInterval(Double(seed.dueInDays) * day), contact: contact))
      }
      try? context.save()
    }
  }
#endif
