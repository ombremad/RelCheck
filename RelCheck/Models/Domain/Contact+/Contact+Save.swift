//
//  Contact+Save.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/02/2026.
//

import SwiftData

extension Contact {
  enum SaveResult {
    case created
    case updated
    case updatedWithDaysChanged
  }

  func update(
    name: String,
    daysBetweenNotifications: Int,
    icon: ContactIcon,
    color: ContactColor,
  ) -> Bool {
    let daysChanged = self.daysBetweenNotifications != daysBetweenNotifications
    self.name = name
    self.daysBetweenNotifications = daysBetweenNotifications
    self.iconName = icon.rawValue
    self.colorName = color.rawValue
    return daysChanged
  }

  static func save(
    contact: Contact?,
    name: String,
    daysBetweenNotifications: Int,
    icon: ContactIcon,
    color: ContactColor,
    modelContext: ModelContext,
  ) -> SaveResult {
    guard let existing = contact else {
      let newContact = Contact(
        name: name,
        daysBetweenNotifications: daysBetweenNotifications,
        icon: icon,
        color: color,
      )
      modelContext.insert(newContact)
      try? modelContext.save()
      newContact.scheduleNextNotification(modelContext: modelContext)
      return .created
    }
    let daysChanged = existing.update(
      name: name,
      daysBetweenNotifications: daysBetweenNotifications,
      icon: icon,
      color: color,
    )
    try? modelContext.save()
    return daysChanged ? .updatedWithDaysChanged : .updated
  }
}
