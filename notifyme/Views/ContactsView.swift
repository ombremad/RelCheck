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
    
    @State private var permissionGranted = false
    
    var body: some View {
        NavigationStack {
            List {
                if contacts.isEmpty {
                    Text("contacts.contactListIsEmpty")
                } else {
                    ForEach(contacts) { contact in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(contact.name)
                                .font(.headline)
                            Text("contacts.everyXDays \(contact.daysBetweenNotifications)")
                                .font(.caption)
                            if contact.nextNotificationDateFormatted != nil {
                                Text("contacts.nextNotificationScheduledOn \(contact.nextNotificationDateFormatted!)")
                                    .font(.caption2)
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
                            VStack(alignment: .leading) {
                                Text("contacts.authorizationWarning.content")
                                    .font(.subheadline)
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
