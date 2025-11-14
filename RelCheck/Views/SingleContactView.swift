//
//  SingleContactView.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//


import SwiftUI
import SwiftData

struct SingleContactView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var contact: Contact
    @State private var hasCheckedIn: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image(systemName: contact.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34, height: 34)
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading) {
                            Text(contact.name)
                                .font(.headline)
                            Text("singleContact.everyXDays \(contact.name) \(contact.daysBetweenNotifications)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                if hasCheckedIn {
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
                } else {
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
                        .buttonStyle(AppButton())
                    }
                    .frame(minHeight: 200)
                }
                Section {
                    VStack(alignment: .leading) {
                        if let nextNotification = contact.nextUpcomingNotification {
                            Text(nextNotification.dateFormatted)
                                .font(.subheadline)
                        } else {
                            Text("singleContact.overdue")
                                .font(.subheadline)
                                .foregroundStyle(.white)
                                .listRowBackground(LinearGradient.destructive)
                        }
                    }
                } header: {
                    Label("singleContact.nextCheckIn", systemImage: "calendar")
                }
                Section {
                    if contact.checkIns.isEmpty {
                        Text("singleContact.noCheckInsYet \(contact.name)")
                            .font(.subheadline)
                    } else {
                        ForEach(contact.checkIns.reversed()) { checkIn in
                            Text(checkIn.dateFormatted)
                                .font(.subheadline)
                        }
                    }
                } header: {
                    Label("singleContact.header.lastCheckIns", systemImage: "ellipsis.message")
                }
            }
            .navigationTitle($contact.name)
            .navigationBarTitleDisplayMode(.inline)
            .alert("singleContact.deleteAlert.title", isPresented: $showDeleteAlert) {
                Button("singleContact.deleteAlert.destructiveButton", role: .destructive) {
                    deleteContact(contact)
                    dismiss()
                }
                Button("singleContact.deleteAlert.dismissButton", role: .cancel) {}
            } message: {
                Text("singleContact.deleteAlert.message")
            }
            .toolbar {
                ToolbarItem(placement: .secondaryAction) {
                    NavigationLink {
                        ContactFormView(contact: contact)
                    } label: {
                        Label("button.edit", systemImage: "pencil")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button("button.delete", systemImage: "trash") {
                        showDeleteAlert = true
                    }
                }
            }
        }
    }
    
    private func checkIn() {
        replaceNotification()
        // Create new model check-in
        let checkIn = CheckIn(date: .now, contact: contact)
        modelContext.insert(checkIn)
        // Change state in view
        hasCheckedIn = true
    }
    private func replaceNotification() {
        // Delete iOS scheduled notification
        if let nextNotification = contact.nextUpcomingNotification {
            NotificationManager.shared.deleteNotification(identifier: nextNotification.notificationID!)
            modelContext.delete(nextNotification)
        }
        // Create new iOS schedule notification
        guard let nextDate = Calendar.current.date(
            byAdding: DateComponents(day: contact.daysBetweenNotifications),
            to: .now
        ) else {
            return
        }
        // Create new model notification
        let notification = Notification(date: nextDate, contact: contact)
        notification.notificationID = NotificationManager.shared.scheduleNotification(
            title: String(localized: "notification.reminder.title \(contact.name)"),
            body: String(localized: "notification.reminder.body"),
            timeInterval: nextDate.timeIntervalSinceNow
        )
        modelContext.insert(notification)
    }
    private func deleteContact(_ contact: Contact) {
        for notification in contact.notifications {
            if let notificationID = notification.notificationID {
                NotificationManager.shared.deleteNotification(identifier: notificationID)
            }
            modelContext.delete(notification)
        }
        modelContext.delete(contact)
        dismiss()
    }
}

#Preview {
    SingleContactView(contact: Contact(
        name: "Anne",
        daysBetweenNotifications: 7
    ))
}
