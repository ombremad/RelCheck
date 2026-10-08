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
    guard isFastCheckInEnabled else { return }

    let title = String(localized: "notification.fastCheckIn.title")
    let body = String(localized: "notification.fastCheckIn.body")
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
    for offset in 0..<Self.fastCheckInDays {
      guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else {
        continue
      }
      let _ = scheduleNotificationAtDate(
        title: title,
        body: body,
        date: date,
        userInfo: ["action": "viewFastCheckIn"],
        identifier: "\(Self.fastCheckInIdentifierPrefix)\(offset)",
      )
      lastDate = date
    }

    if let lastDate { scheduleFastCheckInInactivityNotification(after: lastDate) }
  }

  private func deleteFastCheckInNotifications() {
    let identifiers =
      (0..<Self.fastCheckInDays).map {
        "\(Self.fastCheckInIdentifierPrefix)\($0)"
      } + [Self.fastCheckInInactivityIdentifier]
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
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

  var isFastCheckInEnabled: Bool { currentSettings?.fastCheckIn ?? false }

  private var fastCheckInHour: Int { min(max(currentSettings?.fastCheckInHour ?? 20, 0), 23) }
}
