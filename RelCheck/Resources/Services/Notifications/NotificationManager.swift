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

  private init() {}
  
  static let fastCheckInDays = 7
  static let fastCheckInIdentifierPrefix = "fast-check-in-"
  static let fastCheckInInactivityIdentifier = "fastcheckin-inactivity-warning"
  static let inactivityNotificationDays = 14

  // Reconcile scheduled notifications at every app launch
  func reconcileNotifications(contacts: [Contact]) {
    deleteAllNotifications()
    scheduleFastCheckInNotifications()
    scheduleContactNotifications(contacts)
    scheduleInactivityNotifications()
  }

  // Get all pending notifications
  func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
      DispatchQueue.main.async { completion(requests) }
    }
  }

  // Cancel a specific notification
  func deleteNotification(identifier: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
      identifier
    ])
  }

  // Cancel all notifications
  func deleteAllNotifications() {
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }
  
  // Schedule a notification at a specific date
  func scheduleNotificationAtDate(
    title: String, body: String, date: Date, userInfo: [String: Any], identifier: String
  ) -> String {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.userInfo = userInfo

    let timeInterval = date.timeIntervalSinceNow
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request)

    return identifier
  }
}
