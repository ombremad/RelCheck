//
//  ContactsView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

struct ContactsView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Contact.name) private var contacts: [Contact]
    
    var sortedContacts: [Contact] {
        contacts.sorted { contact1, contact2 in
            let date1 = contact1.nextUpcomingNotification?.date
            let date2 = contact2.nextUpcomingNotification?.date
            
            // Contacts without notifications come first
            switch (date1, date2) {
            case (nil, nil):
                return contact1.name < contact2.name // Sort by name if both nil
            case (nil, _):
                return true  // contact1 has no notification, comes first
            case (_, nil):
                return false // contact2 has no notification, comes first
            case (let d1?, let d2?):
                return d1 < d2 // Both have notifications, sort by date
            }
        }
    }
    
    @State private var permissionGranted = false
    
    var body: some View {
        if hasSeenOnboarding {
            NavigationStack {
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
                            NavigationLink {
                                SingleContactView(contact: contact)
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
                    ToolbarItem(placement: .secondaryAction) {
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label("button.about", systemImage: "person.fill.questionmark")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            ContactFormView()
                        } label: {
                            Label("button.addContact", systemImage: "person.crop.circle.fill.badge.plus")
                        }
                    }
                }
                .task {
                    NotificationManager.shared.requestPermission { granted in
                        permissionGranted = granted
                    }
                }
            }
        } else {
            OnboardingView()
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
