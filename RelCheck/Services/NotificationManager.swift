//
//  NotificationManager.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request permission to send notifications
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // Request permission again through settings if first time was dismissed
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    // Schedule contact notification at a time interval
    func scheduleContactNotification(
        title: String,
        body: String,
        timeInterval: TimeInterval,
        contactID: String,
        identifier: String = UUID().uuidString
    ) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        content.userInfo = [
            "contactID": contactID,
            "action": "viewContact"
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        return identifier
    }
    
    // Schedule contact notification at a specific date
    func scheduleContactNotificationAtDate(
        title: String,
        body: String,
        date: Date,
        contactID: String,
        identifier: String = UUID().uuidString
    ) -> String {
        scheduleNotificationAtDate(
            title: title,
            body: body,
            date: date,
            userInfo: ["action": "viewContact", "contactID": contactID],
            identifier: identifier
        )
    }    
    
    // Schedule daily recap at 8pm
    func scheduleFastCheckInNotification(
        title: String = String(localized: "notification.fastCheckIn.title"),
        body: String = String(localized: "notification.fastCheckIn.body"),
        identifier: String = "fast-check-in"
    ) -> String {
        let now = Date()
        let calendar = Calendar.current
        
        // Try to get today at 8pm
        var targetDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now)!
        
        // If 8pm today has already passed, schedule for 8pm tomorrow
        if targetDate <= now {
            targetDate = calendar.date(byAdding: .day, value: 1, to: targetDate)!
    }
        
        return scheduleNotificationAtDate(
            title: title,
            body: body,
            date: targetDate,
            userInfo: ["action": "viewFastCheckIn"],
            identifier: identifier
        )
    }
    
    // Get all pending notifications
    func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                completion(requests)
            }
        }
    }
    
    // Cancel a specific notification
    func deleteNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Cancel all notifications
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Reconcile scheduled notifications at every app launch
    func reconcileNotifications(contacts: [Contact]) {
        deleteAllNotifications()
        
        // Reschedule notifications for each contact with an upcoming notification
        for contact in contacts {
            guard let nextNotification = contact.nextUpcomingNotification else {
                continue
            }
            
            // Only schedule if the notification is in the future
            guard nextNotification.date > Date() else {
                continue
            }
            
            let title = String(localized: "notification.reminder.title \(contact.name)")
            let body = String(localized: "notification.reminder.body")
            
            // Schedule the contact notification using the exact date from the notification object
            let identifier = scheduleContactNotificationAtDate(
                title: title,
                body: body,
                date: nextNotification.date,
                contactID: contact.id.debugDescription,
                identifier: nextNotification.notificationID ?? UUID().uuidString
            )
            
            // Update the notification's ID if it was newly generated
            if nextNotification.notificationID == nil {
                nextNotification.notificationID = identifier
            }
        }
    }
    
    private func scheduleNotificationAtDate(
        title: String,
        body: String,
        date: Date,
        userInfo: [String: Any],
        identifier: String
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
