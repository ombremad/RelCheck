//
//  ContactsView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

struct ContactsView: View {
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
        NavigationStack {
            List {
                if contacts.isEmpty {
                    VStack(alignment: .center, spacing: 16) {
                        Image(systemName: "questionmark.app.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(LinearGradient(colors: [.accent, .mint], startPoint: .top, endPoint: .bottom))
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
                        VStack(alignment: .leading, spacing: 4) {
                            Text(contact.name)
                                .font(.headline)
                            Text("contacts.everyXDays \(contact.daysBetweenNotifications)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if let nextNotification = contact.nextUpcomingNotification {
                                Text("contacts.nextNotificationScheduledOn \(nextNotification.dateFormatted)")
                                    .font(.caption)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(contact)
                            } label: {
                                Label("button.delete", systemImage: "trash")
                            }
                        }
                    }
                }
                if permissionGranted == false {
                    Section {
                        HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.circle")
                                .font(.title)
                                .foregroundStyle(.black)
                            VStack(alignment: .leading) {
                                Text("contacts.authorizationWarning.content")
                                    .font(.subheadline)
                                    .foregroundStyle(.black)
                                Button("contacts.authorizationWarning.openSettings") {
                                    NotificationManager.shared.openSettings()
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    } header: {
                        Text("contacts.authorizationWarning.title")
                    }
                    .listRowBackground(Color.yellow)
                }
            }
            .navigationTitle("contacts.title")
            .toolbar {
                ToolbarItem(placement: .secondaryAction) {
                    //DEBUG BUTTON!
                    NavigationLink {
                        DebugView()
                    } label: {
                        Label("button.debug", systemImage: "ant")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        NewContactView()
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
    }
}

#Preview {
    ContactsView()
}
