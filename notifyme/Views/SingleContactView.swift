//
//  SingleContactView.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//


import SwiftUI
import SwiftData

struct SingleContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var contact: Contact
    @State private var hasCheckedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                if hasCheckedIn {
                    Section {
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "checkmark.message.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(maxWidth: 55)
                            HStack {
                                Spacer()
                                Text("singleContact.checkInCompleted")
                                    .font(.headline)
                                Spacer()
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(minHeight: 200)
                        .listRowBackground(LinearGradient.primary)
                    }
                } else {
                    Section {
                        VStack(alignment: .center, spacing: 16) {
                            Image(systemName: "questionmark.message.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(LinearGradient.primary)
                                .frame(maxWidth: 55)
                            HStack {
                                Spacer()
                                Text("singleContact.didYouJustCheckInWith \(contact.name)")
                                    .font(.headline)
                                Spacer()
                            }
                            Button("button.checkIn") {
                                checkIn()
                            }
                            .buttonStyle(.glassProminent)
                        }
                        .frame(minHeight: 200)
                    }
                }
                Section {
                    VStack(alignment: .leading) {
                        if let nextNotification = contact.nextUpcomingNotification {
                            Text("singleContact.nextCheckInIsDueBy")
                                .font(.footnote)
                            Text(nextNotification.dateFormatted)
                                .font(.subheadline)
                        } else {
                            Text("singleContact.checkInOverdue")
                                .font(.footnote)
                        }
                    }
                }
            }
            .navigationTitle($contact.name)
        }
    }
    
    private func checkIn() {
        if let nextNotification = contact.nextUpcomingNotification {
            NotificationManager.shared.deleteNotification(identifier: nextNotification.notificationID!)
            modelContext.delete(nextNotification)
        }
        guard let nextDate = Calendar.current.date(
            byAdding: DateComponents(day: contact.daysBetweenNotifications),
            to: .now
        ) else {
            return
        }
        let notification = Notification(date: nextDate, contact: contact)
        notification.notificationID = NotificationManager.shared.scheduleNotification(
            title: String(localized: "notification.reminder.title \(contact.name)"),
            body: String(localized: "notification.reminder.body"),
            timeInterval: nextDate.timeIntervalSinceNow
        )
        modelContext.insert(notification)
        hasCheckedIn = true
    }
}

#Preview {
    SingleContactView(contact: Contact(
        name: "Anne",
        daysBetweenNotifications: 7
    ))
}
