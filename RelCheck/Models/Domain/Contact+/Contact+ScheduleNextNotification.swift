//
//  Contact+ScheduleNextNotification.swift
//  RelCheck
//
//  Created by Anne Ferret on 11/02/2026.
//

import Foundation
import SwiftData

// Contact+ScheduleNextNotification.swift
extension Contact {
  func scheduleNextNotification(modelContext: ModelContext) {
    // Delete all existing notifications
    NotificationManager.shared.deleteNotifications(identifiers: notifications?.compactMap(\.notificationID) ?? [])
    for notification in notifications ?? [] { modelContext.delete(notification) }

    // Schedule a new notification
    guard
      let nextDate = Calendar.current.date(
        byAdding: DateComponents(day: daysBetweenNotifications),
        to: .now,
      )
    else { return }

    let notification = Notification(date: nextDate, contact: self)
    notification.notificationID = NotificationManager.shared.scheduleContactNotificationAtDate(
      date: nextDate,
      contact: self,
    )
    modelContext.insert(notification)
  }
}
