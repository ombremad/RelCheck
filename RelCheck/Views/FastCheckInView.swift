//
//  DailyRecapView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

@MainActor
struct FastCheckInView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    @Query(sort: \Contact.name) private var contacts: [Contact]
    
    @State private var selectedContacts: [Contact] = []
    
    var body: some View {
        List {
            Section {
                Text("fastCheckIn.intro")
                    .font(.callout)
            }
            
            Section {
                ForEach(contacts) { contact in
                    FastCheckInContactRow(
                        contact: contact,
                        isSelected: selectedContacts.contains(contact)
                    ) {
                        toggleSelection(for: contact)
                    }
                }
            }
        }
        
        .navigationTitle("fastCheckIn.title")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("button.save", systemImage: "checkmark") {
                    saveRecap()
                    navigator.back()
                }
            }
        }
    }
    
    private func toggleSelection(for contact: Contact) {
        withAnimation {
            if selectedContacts.contains(contact) {
                selectedContacts.removeAll(where: { $0 == contact })
            } else {
                selectedContacts.append(contact)
            }
        }
    }
    
    private func saveRecap() {
        for contact in selectedContacts {
            
            // Replace notification
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
            notification.notificationID = NotificationManager.shared.scheduleContactNotification(
                timeInterval: nextDate.timeIntervalSinceNow,
                contact: contact
            )
            modelContext.insert(notification)

            // Add check-in
            let checkIn = CheckIn(date: .now, contact: contact)
            modelContext.insert(checkIn)
        }
        
        // Save changes
        try? modelContext.save()
    }
}

#Preview {
    FastCheckInView()
}
