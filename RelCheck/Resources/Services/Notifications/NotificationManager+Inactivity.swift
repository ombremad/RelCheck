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
    scheduleFastCheckInInactivityNotification()
  }

  private func scheduleAppInactivityNotification() {
    guard let targetDate = Calendar.current.date(byAdding: .day, value: Self.inactivityNotificationDays, to: .now)
    else { return }

    let _ = scheduleNotificationAtDate(
      title: String(localized: "notification.inactivity.app.title"),
      body: String(localized: "notification.inactivity.app.body"),
      date: targetDate,
      userInfo: [:],
      identifier: "app-inactivity-warning",
    )
  }

  func scheduleFastCheckInInactivityNotification() {
    guard isFastCheckInEnabled,
      let targetDate = Calendar.current.date(byAdding: .day, value: Self.fastCheckInDays, to: .now)
    else { return }

    let _ = scheduleNotificationAtDate(
      title: String(localized: "notification.inactivity.fastCheckIn.title"),
      body: String(localized: "notification.inactivity.fastCheckIn.body"),
      date: targetDate,
      userInfo: [:],
      identifier: "fastcheckin-inactivity-warning",
    )
  }
}
