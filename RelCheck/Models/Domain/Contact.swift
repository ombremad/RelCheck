//
//  Contact.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import Foundation
import SwiftData

@Model class Contact {
  var id: UUID = UUID()
  var name: String = ""
  var daysBetweenNotifications: Int = 7
  var iconName: String = ContactIcon.personFill.rawValue
  var colorName: String = ContactColor.gray.rawValue

  @Relationship(deleteRule: .cascade, inverse: \Notification.contact)
  var notifications: [Notification]? = []

  @Relationship(deleteRule: .cascade, inverse: \CheckIn.contact)
  var checkIns: [CheckIn]? = []

  @Transient var nextUpcomingNotification: Notification? {
    notifications?.filter { !$0.isCompleted && $0.date > Date() }.sorted { $0.date < $1.date }.first
  }

  @Transient var icon: ContactIcon {
    ContactIcon(rawValue: iconName) ?? .personFill
  }

  @Transient var color: ContactColor {
    ContactColor(rawValue: colorName) ?? .gray
  }

  init(
    name: String,
    daysBetweenNotifications: Int,
    icon: ContactIcon = .personFill,
    color: ContactColor = .gray
  ) {
    self.id = UUID()
    self.name = name
    self.daysBetweenNotifications = daysBetweenNotifications
    self.iconName = icon.rawValue
    self.colorName = color.rawValue
  }
}
