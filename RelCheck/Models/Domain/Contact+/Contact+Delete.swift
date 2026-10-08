//
//  Contact+Delete.swift
//  RelCheck
//
//  Created by Anne Ferret on 12/02/2026.
//

import SwiftData

extension Contact {
  func delete(from modelContext: ModelContext) {
    NotificationManager.shared.deleteNotifications(identifiers: notifications?.compactMap(\.notificationID) ?? [])
    for notification in notifications ?? [] { modelContext.delete(notification) }
    modelContext.delete(self)
  }
}
