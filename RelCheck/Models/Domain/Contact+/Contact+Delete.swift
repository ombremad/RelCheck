//
//  Contact+Delete.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/02/2026.
//

import Foundation
import SwiftData

extension Contact {
    @MainActor
    func delete(from modelContext: ModelContext) {
        for notification in notifications ?? [] {
            if let notificationID = notification.notificationID {
                NotificationManager.shared.deleteNotification(identifier: notificationID)
            }
            modelContext.delete(notification)
        }
        modelContext.delete(self)
    }
}
