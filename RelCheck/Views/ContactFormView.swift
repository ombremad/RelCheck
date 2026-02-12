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
                        navigator.back()
                    }
                    Button("button.changedDays.changeCheckIn \(existingContact.daysBetweenNotifications)") {
                        createNotification(for: existingContact)
                        navigator.back()
                    }
                }
            }
        } message: {
            Text("editContact.changedDays.message")
        }
    }
    
    // Functions
    private func saveContact() {
        switch Contact.save(
            contact: contactToEdit,
            name: name,
            daysBetweenNotifications: daysBetweenNotifications,
            icon: selectedIcon,
            modelContext: modelContext
        ) {
            case .created, .updated:
                navigator.back()
            case .updatedWithDaysChanged:
                showEditAlert = true
        }
    }
    
    private func createNotification(for contact: Contact) {
        contact.scheduleNextNotification(modelContext: modelContext)
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
