//
//  NotificationManager+FastCheckIn.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import SwiftData
import UserNotifications

extension NotificationManager {
  // Schedule daily recaps at 8pm
  func scheduleFastCheckInNotifications() {
    deleteFastCheckInNotifications()
    guard isFastCheckInEnabled else { return }
    
    let title = String(localized: "notification.fastCheckIn.title")
    let body = String(localized: "notification.fastCheckIn.body")
    let now = Date()
    let calendar = Calendar.current
    
    // First 8pm still in the future: today if it hasn't passed, otherwise tomorrow
    guard var firstDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) else {
      return
    }
    if firstDate <= now {
      guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: firstDate) else { return }
      firstDate = tomorrow
    }
    
    for offset in 0..<Self.fastCheckInDays {
      guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else {
        continue
      }
      let _ = scheduleNotificationAtDate(
        title: title, body: body, date: date, userInfo: ["action": "viewFastCheckIn"],
        identifier: "\(Self.fastCheckInIdentifierPrefix)\(offset)")
    }
    
    scheduleFastCheckInInactivityNotification()
  }
    
  private func deleteFastCheckInNotifications() {
    let identifiers = (0..<Self.fastCheckInDays).map {
      "\(Self.fastCheckInIdentifierPrefix)\($0)"
    }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
  }
  
  // Current settings row, created with defaults if it doesn't exist yet
  private var currentSettings: Settings? {
    guard let modelContext else { return nil }
    
    if let settings = try? modelContext.fetch(FetchDescriptor<Settings>()).first {
      return settings
    }
    
    let settings = Settings()
    modelContext.insert(settings)
    return settings
  }
  
  // Whether the user turned the daily fast check-in on
  var isFastCheckInEnabled: Bool { currentSettings?.fastCheckIn ?? false }
  
  // Hour of day (0–23) for the daily recap
  private var fastCheckInHour: Int { min(max(currentSettings?.fastCheckInHour ?? 20, 0), 23) }
}
