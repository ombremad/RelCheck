//
//  NewContactView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//


import SwiftUI
import SwiftData

struct NewContactView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var newContact: Contact = Contact(name: "", daysBetweenNotifications: 7, nextNotification: nil)
    
    private var isNameValid: Bool {
        !newContact.name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("newContact.header.contactInformation") {
                    TextField("newContact.inputField.name", text: $newContact.name)
                }
                Section("newContact.header.notificationSetting") {
                    Stepper("newContact.stepper.everyXDays \(newContact.daysBetweenNotifications)", value: $newContact.daysBetweenNotifications, in: 1...60)
                }
            }
            .navigationTitle("newContact.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("button.save") {
                        // Calculate and generate next notification Date for the contact
                        newContact.nextNotificationDate = Calendar.current.date(byAdding: DateComponents(day: newContact.daysBetweenNotifications), to: .now)
                        
                        // Schedule next notification and get its ID
                        newContact.nextNotificationID = NotificationManager.shared.scheduleNotification(title: "notification.hello", body: "notification.scheduledNotificationGreeting", timeInterval: newContact.nextNotificationDate?.timeIntervalSinceNow ?? 0)
                        
                        // Save new contact in model and dismiss
                        modelContext.insert(newContact)
                        dismiss()
                    }
                    .disabled(!isNameValid)
                }
            }
        }
    }
}
