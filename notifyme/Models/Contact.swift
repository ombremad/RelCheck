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
    
    @Relationship(deleteRule: .cascade, inverse: \Notification.contact)
    var notifications: [Notification] = []

    var nextUpcomingNotification: Notification? {
        notifications
            .filter { !$0.isCompleted && $0.date > Date() }
            .sorted { $0.date < $1.date }
            .first
    }
    
    init(name: String, daysBetweenNotifications: Int) {
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
    }
}
