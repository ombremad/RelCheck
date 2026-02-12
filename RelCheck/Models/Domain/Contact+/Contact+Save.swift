//
//  Contact+Save.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/02/2026.
//

import Foundation
import SwiftData

extension Contact {
    enum SaveResult {
        case created
        case updated
        case updatedWithDaysChanged
    }
    
    @MainActor
    func update(name: String, daysBetweenNotifications: Int, icon: AppIcon) -> Bool {
        let daysChanged = self.daysBetweenNotifications != daysBetweenNotifications
        self.name = name
        self.daysBetweenNotifications = daysBetweenNotifications
        self.iconName = icon.rawValue
        return daysChanged
    }
    
    @MainActor
    static func save(
        contact: Contact?,
        name: String,
        daysBetweenNotifications: Int,
        icon: AppIcon,
        modelContext: ModelContext
    ) -> SaveResult {
        if let existing = contact {
            let daysChanged = existing.update(
                name: name,
                daysBetweenNotifications: daysBetweenNotifications,
                icon: icon
            )
            try? modelContext.save()
            return daysChanged ? .updatedWithDaysChanged : .updated
        } else {
            let newContact = Contact(
                name: name,
                daysBetweenNotifications: daysBetweenNotifications,
                icon: icon
            )
            modelContext.insert(newContact)
            try? modelContext.save()
            newContact.scheduleNextNotification(modelContext: modelContext)
            return .created
        }
    }
}
