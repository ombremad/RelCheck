//
//  Notification.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import Foundation
import SwiftData

@Model
class Notification {
    var date: Date
    var notificationID: String?
    var isCompleted: Bool = false
    
    var contact: Contact?
    
    var dateFormatted: String {
        date.formatted(date: .complete, time: .omitted)
    }
        
    init(date: Date, contact: Contact) {
        self.date = date
        self.contact = contact
    }
}
