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
        
    // Schedule a local notification
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval, identifier: String = UUID().uuidString) -> String {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Create a time-based trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled with identifier: \(identifier)")
            }
        }
        
        // Returns notification ID (as String)
        return identifier
    }
    
    // Schedule a local notification at a specific date
    func scheduleNotificationAtDate(title: String, body: String, date: Date, identifier: String = UUID().uuidString) -> String {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // Calculate time interval from now to the target date
        let timeInterval = date.timeIntervalSinceNow
        
        // Create a time-based trigger (more reliable than calendar trigger for specific dates)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        // Create the request
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled for \(date) with identifier: \(identifier)")
            }
        }
        
        // Returns notification ID (as String)
        return identifier
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
            
            // Schedule the notification using the exact date from the notification object
            let identifier = scheduleNotificationAtDate(
                title: title,
                body: body,
                date: nextNotification.date,
                identifier: nextNotification.notificationID ?? UUID().uuidString
            )
            
            // Update the notification's ID if it was newly generated
            if nextNotification.notificationID == nil {
                nextNotification.notificationID = identifier
            }
        }
        
        print("Reconciled notifications for \(contacts.count) contacts")
    }
}
