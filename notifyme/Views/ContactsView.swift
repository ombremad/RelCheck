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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(contact.name)
                            .font(.headline)
                        
                        HStack {
                            Text("Every \(contact.daysBetweenNotifications) days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            if let nextNotif = contact.nextNotification {
                                Text("• Next: \(nextNotif.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(contact)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        NewContactView()
                    } label: {
                        Label("Add Contact", systemImage: "person.crop.circle.fill.badge.plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContactsView()
}
