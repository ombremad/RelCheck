//
//  NotificationManager+Contacts.swift
//  RelCheck
//
//  Created by Anne Ferret on 20/09/2026.
//

import UserNotifications

extension NotificationManager {
  // Reschedule notifications for each contact
  func scheduleContactNotifications(_ contacts: [Contact]) {
    for contact in contacts {
      guard let nextNotification = contact.nextUpcomingNotification else { continue }
      
      // Only schedule if the notification is in the future
      guard nextNotification.date > Date() else { continue }
      
      // Schedule the contact notification using the exact date from the notification object
      let identifier = scheduleContactNotificationAtDate(
        date: nextNotification.date, contact: contact,
        identifier: nextNotification.notificationID ?? UUID().uuidString)
      
      // Update the notification's ID if it was newly generated
      if nextNotification.notificationID == nil { nextNotification.notificationID = identifier }
    }
  }

  // Schedule contact notification at a time interval
  func scheduleContactNotification(
    timeInterval: TimeInterval, contact: Contact, identifier: String = UUID().uuidString
  ) -> String {
    let content = UNMutableNotificationContent()
    content.title = String(localized: "notification.reminder.title \(contact.name)")
    content.body = String(localized: "notification.reminder.body")
    content.sound = .default
    
    content.userInfo = ["contactID": contact.id.uuidString, "action": "viewContact"]
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
    
    return identifier
  }
  
  // Schedule contact notification at a specific date
  func scheduleContactNotificationAtDate(
    date: Date, contact: Contact, identifier: String = UUID().uuidString
  ) -> String {
    scheduleNotificationAtDate(
      title: String(localized: "notification.reminder.title \(contact.name)"),
      body: String(localized: "notification.reminder.body"), date: date,
      userInfo: ["action": "viewContact", "contactID": contact.id.uuidString],
      identifier: identifier)
  }
}
