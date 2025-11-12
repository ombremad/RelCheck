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
                ForEach(contacts) { contact in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(contact.name)
                            .font(.headline)
                        HStack {
                            Text("contacts.everyXDays \(contact.daysBetweenNotifications)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
                if permissionGranted == false {
                    Section {
                        HStack {
                            Image(systemName: "exclamationmark.circle")
                                .font(.title)
                            Text("contacts.authorizationWarning.content")
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
