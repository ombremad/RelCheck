//
//  ContactFormView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import SwiftData

struct ContactFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let contactToEdit: Contact?
    
    @State private var name: String
    @State private var daysBetweenNotifications: Int
    @State private var selectedIcon: AppIcon
    
    private var isEditing: Bool {
        contactToEdit != nil
    }
    
    private var isContactValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(contact: Contact? = nil) {
        self.contactToEdit = contact
        _name = State(initialValue: contact?.name ?? "")
        _daysBetweenNotifications = State(initialValue: contact?.daysBetweenNotifications ?? 7)
        _selectedIcon = State(initialValue: contact?.icon ?? .personFill)
    }
    
    var body: some View {
        NavigationStack {
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
        }
    }
    
    private func saveContact() {
        if let existingContact = contactToEdit {
            // edit an existing contact
            existingContact.name = name
            existingContact.daysBetweenNotifications = daysBetweenNotifications
            existingContact.iconName = selectedIcon.rawValue
        } else {
            // create a new contact
            let newContact = Contact(
                name: name,
                daysBetweenNotifications: daysBetweenNotifications,
                icon: selectedIcon
            )
            modelContext.insert(newContact)
            // initialize the first notification
            createNotification(for: newContact)
        }
        dismiss()
    }
    
    private func createNotification(for contact: Contact) {
        guard let nextDate = Calendar.current.date(
            byAdding: DateComponents(day: contact.daysBetweenNotifications),
            to: .now
        ) else {
            return
        }
        let notification = Notification(date: nextDate, contact: contact)
        notification.notificationID = NotificationManager.shared.scheduleNotification(
            title: String(localized: "notification.reminder.title \(contact.name)"),
            body: String(localized: "notification.reminder.body"),
            timeInterval: nextDate.timeIntervalSinceNow
        )
        modelContext.insert(notification)
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
