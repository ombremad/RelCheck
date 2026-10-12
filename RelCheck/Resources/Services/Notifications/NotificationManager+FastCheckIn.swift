//
//  NotificationManager+FastCheckIn.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftData
import UserNotifications

extension NotificationManager {

  func scheduleFastCheckInNotifications() {
    deleteFastCheckInNotifications()
    addFastCheckInNotifications()
  }

  // Schedule fast check-in notifications, assuming previous ones were already removed
  func addFastCheckInNotifications() {
    guard let settings = currentSettings, settings.fastCheckIn else { return }
    let fastCheckInHour = min(max(settings.fastCheckInHour, 0), 23)

    let now = Date()
    let calendar = Calendar.current

    guard var firstDate = calendar.date(bySettingHour: fastCheckInHour, minute: 0, second: 0, of: now) else {
      return
    }
    if firstDate <= now {
      guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: firstDate) else { return }
      firstDate = tomorrow
    }

    var lastDate: Date?
    for offset in 0..<Self.fastCheckInInactivityDays {
      guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else {
        continue
      }
      let _ = scheduleFastCheckInNotificationAtDate(
        date: date,
        identifier: "\(Self.fastCheckInIdentifierPrefix)\(offset)",
      )
      lastDate = date
    }

    if let lastDate { scheduleFastCheckInInactivityNotification(after: lastDate) }
  }

  // Schedule fast check-in notification at a specific date
  func scheduleFastCheckInNotificationAtDate(
    date: Date,
    identifier: String = UUID().uuidString,
  ) -> String {
    scheduleNotificationAtDate(
      title: String(localized: "notification.fastCheckIn.title"),
      body: String(localized: "notification.fastCheckIn.body"),
      date: date,
      userInfo: ["action": "viewFastCheckIn"],
      identifier: identifier,
    )
  }

  private func deleteFastCheckInNotifications() {
    let identifiers =
      (0..<Self.fastCheckInInactivityDays).map {
        "\(Self.fastCheckInIdentifierPrefix)\($0)"
      } + [Self.fastCheckInInactivityIdentifier]
    deleteNotifications(identifiers: identifiers)
  }

  private var currentSettings: Settings? {
    guard let modelContext else { return nil }

    if let settings = try? modelContext.fetch(FetchDescriptor<Settings>()).first {
      return settings
    }

    let settings = Settings()
    modelContext.insert(settings)
    return settings
  }
}
