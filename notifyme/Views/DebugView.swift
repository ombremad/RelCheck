//
//  DebugView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var pendingNotifications: [UNNotificationRequest] = [] 

    var body: some View {
        List {
            Section {
                if pendingNotifications.isEmpty {
                    Text("debug.noScheduledNotification")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(pendingNotifications, id: \.identifier) { notification in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.content.title)
                                .font(.headline)
                            Text(notification.content.body)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if let trigger = notification.trigger as? UNTimeIntervalNotificationTrigger {
                                let fireDate = Date(timeIntervalSinceNow: trigger.timeInterval)
                                Text(fireDate.formatted(date: .long, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                            Text("debug.id \(notification.identifier)")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            } header: {
                Text("debug.header.scheduledNotifications")
            }
            Section {
                Button("debug.deleteAllSystemScheduledNotifications") {
                    NotificationManager.shared.deleteAllNotifications()
                    loadNotifications()
                }
                Button("debug.deleteAllContacts") {
                    try? modelContext.delete(model: Contact.self)
                }
            } header: {
                Text("debug.header.actions")
            }
        }
        .task {
            loadNotifications()
        }
    }
    
    private func loadNotifications() {
        NotificationManager.shared.getPendingNotifications { notifications in
            pendingNotifications = notifications.sorted {
                guard let trigger1 = $0.trigger as? UNTimeIntervalNotificationTrigger,
                      let trigger2 = $1.trigger as? UNTimeIntervalNotificationTrigger else {
                    return false
                }
                return trigger1.timeInterval < trigger2.timeInterval
            }
        }
    }
}
