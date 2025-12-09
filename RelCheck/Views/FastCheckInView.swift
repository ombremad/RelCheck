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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
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
                    let isSelected = selectedContacts.contains(contact)
                    
                    HStack(spacing: 8) {
                        Image(systemName: contact.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(isSelected ? .white : .secondary)
                            .frame(width: 28, height: 28)
                        Text(contact.name)
                            .font(.headline)
                            .foregroundStyle(isSelected ? .white : .primary)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .listRowBackground(isSelected ? Color.accentColor : nil)
                    
                    .onTapGesture {
                        if selectedContacts.contains(contact) {
                            withAnimation {
                                selectedContacts.removeAll(where: { $0 == contact })
                            }
                        } else {
                            withAnimation {
                                selectedContacts.append(contact)
                            }
                        }
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
                    dismiss()
                }
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
