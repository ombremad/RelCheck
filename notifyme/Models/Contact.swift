//
//  Contact.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import Foundation
import SwiftData

@Model
class Contact {
    var name: String
    var daysBetweenNotifications: Int
    var nextNotificationDate: Date?
    var nextNotificationDateFormatted: String? {
        nextNotificationDate?.formatted(date: .abbreviated, time: .omitted)
    }
    var nextNotificationID: String?
    
    init(name: String, daysBetweenNotifications: Int, nextNotification: Date?) {
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
        self.nextNotificationDate = nextNotification ?? Date()
    }
}
