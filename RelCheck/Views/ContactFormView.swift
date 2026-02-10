//
//  ContactFormView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import SwiftData

@MainActor
struct ContactFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    private let contactToEdit: Contact?
    
    // Form values
    @State private var name: String
    @State private var daysBetweenNotifications: Int
    @State private var selectedIcon: AppIcon
    
    // Computed properties
    private var isEditing: Bool {
        contactToEdit != nil
    }
    private var isContactValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // UX values
    @State private var showEditAlert: Bool = false
    
    init(contact: Contact? = nil) {
        self.contactToEdit = contact
        _name = State(initialValue: contact?.name ?? "")
        _daysBetweenNotifications = State(initialValue: contact?.daysBetweenNotifications ?? 7)
        _selectedIcon = State(initialValue: contact?.icon ?? .personFill)
    }
    
    var body: some View {
        Form {
            Section("newContact.header.contactInformation") {
                TextField("newContact.inputField.name", text: $name)
            }
            Section("newContact.header.contactIcon") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                    ForEach(AppIcon.allCases, id: \.self) { icon in
                        icon.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(selectedIcon == icon ? .accent : .primary)
                            .frame(width: 36, height: 36)
                            .onTapGesture {
                                selectedIcon = icon
                            }
                    }
                }
            }
            Section("newContact.header.notificationSetting") {
                Stepper("newContact.stepper.everyXDays \(daysBetweenNotifications)", value: $daysBetweenNotifications, in: 1...60)
            }
        }
        .navigationTitle(isEditing ? "editContact.title" : "newContact.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("button.save", systemImage: "checkmark") {
                    saveContact()
                }
                .disabled(!isContactValid)
            }
        }
        
        .alert("editContact.changedDays.title", isPresented: $showEditAlert) {
            if let existingContact = contactToEdit {
                if let nextPlannedCheckIn = existingContact.nextUpcomingNotification?.dateFormatted {
                    Button("button.changedDays.keepCurrentCheckIn \(nextPlannedCheckIn)") {
                        navigator.navigateBack()
                    }
                    Button("button.changedDays.changeCheckIn \(existingContact.daysBetweenNotifications)") {
                        createNotification(for: existingContact)
                        navigator.navigateBack()
                    }
                }
            }
        } message: {
            Text("editContact.changedDays.message")
        }
    }
    
    // Functions
    private func saveContact() {
        if let existingContact = contactToEdit {
            // edit an existing contact
            var daysChanged: Bool = false
            if existingContact.daysBetweenNotifications != daysBetweenNotifications {
                daysChanged = true
            }
            existingContact.name = name
            existingContact.daysBetweenNotifications = daysBetweenNotifications
            existingContact.iconName = selectedIcon.rawValue
            try? modelContext.save()
            if daysChanged {
                showEditAlert = true
            } else {
                navigator.navigateBack()
            }
        } else {
            // create a new contact
            let newContact = Contact(
                name: name,
                daysBetweenNotifications: daysBetweenNotifications,
                icon: selectedIcon
            )
            modelContext.insert(newContact)
            try? modelContext.save()
            // initialize the first notification
            createNotification(for: newContact)
            navigator.navigateBack()
        }
    }
    
    private func createNotification(for contact: Contact) {
        for notification in contact.notifications ?? [] {
            if let notificationID = notification.notificationID {
                NotificationManager.shared.deleteNotification(identifier: notificationID)
            }
            modelContext.delete(notification)
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
        try? modelContext.save()
    }
}

#Preview("New Contact") {
    ContactFormView()
}

#Preview("Edit Contact") {
    ContactFormView(contact: Contact(
        name: "Anne",
        daysBetweenNotifications: 3,
        icon: .bicycle
    ))
}
