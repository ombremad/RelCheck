//
//  NotificationManager+Inactivity.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import UserNotifications

extension NotificationManager {
  func scheduleInactivityNotifications() {
    scheduleAppInactivityNotification()
  }

  private func scheduleAppInactivityNotification() {
    guard let targetDate = Self.inactivityLastReminderDate
    else { return }

    let _ = scheduleNotificationAtDate(
      title: String(localized: "notification.inactivity.app.title"),
      body: String(localized: "notification.inactivity.app.body"),
      date: targetDate,
      userInfo: [:],
      identifier: "app-inactivity",
    )
  }

  func scheduleFastCheckInInactivityNotification(after lastFastCheckIn: Date) {
    let targetDate = lastFastCheckIn.addingTimeInterval(24 * 60 * 60)

    let _ = scheduleNotificationAtDate(
      title: String(localized: "notification.inactivity.fastCheckIn.title"),
      body: String(localized: "notification.inactivity.fastCheckIn.body"),
      date: targetDate,
      userInfo: [:],
      identifier: Self.fastCheckInInactivityIdentifier,
    )
  }
}
