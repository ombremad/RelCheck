//
//  NotificationManager.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftData
import UserNotifications

class NotificationManager {
  static let shared = NotificationManager()
  var modelContext: ModelContext?

  private let center = UNUserNotificationCenter.current()
  private let queue = DispatchQueue(label: "ombremad.notifyme.notifications", qos: .utility)

  private init() {}

  static let fastCheckInInactivityDays = 3
  static let appInactivityDays = 30
  static let appInactivityDate = Calendar.current.date(
    byAdding: .day,
    value: appInactivityDays,
    to: .now,
  )

  static let fastCheckInIdentifierPrefix = "fast-check-in-"
  static let fastCheckInInactivityIdentifier = "fast-check-in-inactivity"

  // Reconcile scheduled notifications at every app launch
  func reconcileNotifications(contacts: [Contact]) {
    deleteAllNotifications()
    addFastCheckInNotifications()
    scheduleContactNotifications(contacts)
    scheduleInactivityNotifications()
  }

  // Get all pending notifications
  func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
    center.getPendingNotificationRequests { requests in
      DispatchQueue.main.async { completion(requests) }
    }
  }

  // Cancel specific notifications
  func deleteNotifications(identifiers: [String]) {
    guard !identifiers.isEmpty else { return }
    queue.async { [center] in center.removePendingNotificationRequests(withIdentifiers: identifiers) }
  }

  // Cancel all notifications
  func deleteAllNotifications() {
    queue.async { [center] in center.removeAllPendingNotificationRequests() }
  }

  // Add a notification request
  func enqueue(_ request: UNNotificationRequest) {
    queue.async { [center] in center.add(request) }
  }

  // Schedule a notification at a specific date
  func scheduleNotificationAtDate(
    title: String,
    body: String,
    date: Date,
    userInfo: [String: Any],
    identifier: String,
  ) -> String {
    // The app goes dormant after the last inactivity reminder: nothing may be scheduled later
    if let lastReminder = Self.appInactivityDate, date > lastReminder { return identifier }

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.userInfo = userInfo

    let timeInterval = date.timeIntervalSinceNow
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    enqueue(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger))

    return identifier
  }
}
