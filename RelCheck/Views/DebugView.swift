//
//  DebugView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

@MainActor
struct DebugView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    @State private var pendingNotifications: [UNNotificationRequest] = []
    
    @State private var hasMadeDemoNotification = false
    @State private var hasDeletedAllUserData = false

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
                Button("debug.seeOnboardingAgain", systemImage: "rectangle.stack") {
                    hasSeenOnboarding = false
                }
                Button("debug.deleteAllUserData", systemImage: "trash") {
                    try? modelContext.delete(model: Contact.self)
                    try? modelContext.delete(model: Notification.self)
                    NotificationManager.shared.deleteAllNotifications()
                    loadNotifications()
                    hasDeletedAllUserData = true
                }
                .opacity(hasDeletedAllUserData ? 0.3 : 1)
                .disabled(hasDeletedAllUserData)
            } header: {
                Text("debug.header.actions")
            }
        }
        .navigationTitle("debug.title")
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

#Preview {
    DebugView()
}
