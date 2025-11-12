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
    var nextNotification: Date?
    
    init(name: String, daysBetweenNotifications: Int, nextNotification: Date?) {
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
        self.nextNotification = nextNotification ?? Date()
    }
}
