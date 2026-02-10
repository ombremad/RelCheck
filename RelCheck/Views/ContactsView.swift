//
//  ContactsView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

@MainActor
struct ContactsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    @Query private var settingsArray: [Settings]
    @Query(sort: \Contact.name) private var contacts: [Contact]

    // Computed properties
    private var settings: Settings {
        if let existing = settingsArray.first {
            return existing
        }
        let newSettings = Settings()
        modelContext.insert(newSettings)
        return newSettings
    }

    private var sortedContacts: [Contact] {
        contacts.sorted { contact1, contact2 in
            let date1 = contact1.nextUpcomingNotification?.date
            let date2 = contact2.nextUpcomingNotification?.date
            
            switch (date1, date2) {
            case (nil, nil):
                return contact1.name < contact2.name
            case (nil, _):
                return true
            case (_, nil):
                return false
            case (let d1?, let d2?):
                return d1 < d2
            }
        }
    }
    
    @State private var permissionGranted = false
    @State private var hasReconciledNotifications = false
    
    var body: some View {
        List {
            if contacts.isEmpty {
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "questionmark.app.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(LinearGradient.primary)
                        .frame(maxWidth: 55)
                    HStack {
                        Spacer()
                        Text("contacts.contactListIsEmpty")
                        Spacer()
                    }
                }
                .frame(minHeight: 200)
            } else {
                ForEach(sortedContacts) { contact in
                    Button {
                        navigator.navigate(to: .singleContact(id: contact.id.uuidString))
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: contact.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.secondary)
                                .frame(width: 28, height: 28)
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text("contacts.everyXDays \(contact.daysBetweenNotifications)")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            Spacer()
                            if let nextNotification = contact.nextUpcomingNotification {
                                Text(String(localized: "contacts.nextCheckInDays \(nextNotification.daysLeftUntilDate)").uppercased())
                                    .font(.caption2.bold())
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(LinearGradient.primary)
                                    .cornerRadius(12)
                            } else {
                                Text("contacts.nextCheckInOverdue")
                                    .font(.caption2.bold())
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(LinearGradient.destructive)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteContact(contact)
                        } label: {
                            Label("button.delete", systemImage: "trash")
                        }
                    }
                }
            }
            if permissionGranted == false {
                Section {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 38)
                            .foregroundStyle(.black)
                        VStack(alignment: .leading) {
                            Text("contacts.authorizationWarning.title")
                                .font(.headline)
                            Text("contacts.authorizationWarning.content")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                            Button("contacts.authorizationWarning.openSettings") {
                                NotificationManager.shared.openSettings()
                            }
                            .buttonStyle(AppButton())
                        }
                    }
                }
                .listRowBackground(Color.yellow)
            }
        }
        
        .navigationTitle("contacts.title")
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigator.navigate(to: .settings)
                } label: {
                    Label("button.settings", systemImage: "gear")
                }
            }
        }
        
        .overlay(alignment: .bottomTrailing) {
            Menu {
                Button {
                    navigator.navigate(to: .newContact)
                } label: {
                    Label("button.addContact", systemImage: "person.badge.plus")
                }
                Button {
                    navigator.navigate(to: .fastCheckIn)
                } label: {
                    Label("fastCheckIn.title", systemImage: "hare")
                }
            } label: {
                Label("button.contactActions", systemImage: "person.fill.checkmark.and.xmark")
            }
            .padding(.trailing, 16)
            .buttonStyle(BigRoundButton())
            .labelStyle(.iconOnly)
        }
        
        .task {
            // Check notifications permissions
            NotificationManager.shared.requestPermission { granted in
                permissionGranted = granted
            }
            
            // Reconcile notifications
            if !hasReconciledNotifications {
                NotificationManager.shared.reconcileNotifications(contacts: contacts)
                if settings.fastCheckIn == true {
                    let _ = NotificationManager.shared.scheduleFastCheckInNotification()
                }
                hasReconciledNotifications = true
            }
        }
    }
    
    private func deleteContact(_ contact: Contact) {
        for notification in contact.notifications ?? [] {
            if let notificationID = notification.notificationID {
                NotificationManager.shared.deleteNotification(identifier: notificationID)
            }
            modelContext.delete(notification)
        }
        modelContext.delete(contact)
    }

}


#Preview {
    ContactsView()
}
