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
    
    @State private var name: String = ""
    @State private var daysBetweenNotifications: Int = 7
    @State private var nextNotification: Date = Date()
    
    private var isNameValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                }
                
                Section("Notification Settings") {
                    Stepper("Every \(daysBetweenNotifications) days", value: $daysBetweenNotifications, in: 1...365)
                    
                    DatePicker("Next notification", selection: $nextNotification, displayedComponents: [.date])
                }
            }
            .navigationTitle("New Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespaces)
                        let newContact = Contact(
                            name: trimmedName,
                            daysBetweenNotifications: daysBetweenNotifications,
                            nextNotification: nextNotification
                        )
                        modelContext.insert(newContact)
                        dismiss()
                    }
                    .disabled(!isNameValid)
                }
            }
        }
    }
}
