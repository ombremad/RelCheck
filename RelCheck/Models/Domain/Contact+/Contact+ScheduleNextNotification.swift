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
    @MainActor
    func scheduleNextNotification(modelContext: ModelContext) {
        // Delete all existing notifications
        for notification in notifications ?? [] {
            if let notificationID = notification.notificationID {
                NotificationManager.shared.deleteNotification(identifier: notificationID)
            }
            modelContext.delete(notification)
        }
        
        // Schedule a new notification
        guard let nextDate = Calendar.current.date(
            byAdding: DateComponents(day: daysBetweenNotifications),
            to: .now
        ) else { return }
        
        let notification = Notification(date: nextDate, contact: self)
        notification.notificationID = NotificationManager.shared.scheduleContactNotification(
            timeInterval: nextDate.timeIntervalSinceNow,
            contact: self
        )
        modelContext.insert(notification)
    }
}
