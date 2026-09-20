//
//  ContactFormView.swift
//  notifyme
//
//  Created by Anne Ferret on 12/11/2025.
//

import SwiftUI
import SwiftData

struct ContactFormView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(AppNavigator.self) private var navigator

  private let contactToEdit: Contact?

  // Form values
  @State private var name: String
  @State private var daysBetweenNotifications: Int
  @State private var selectedIcon: ContactIcon
  @State private var selectedColor: ContactColor

  // Computed properties
  private var isEditing: Bool { contactToEdit != nil }
  private var isContactValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty }

  // UX values
  @State private var showEditAlert: Bool = false
  @State private var showIconPicker: Bool = false
  @State private var showColorPicker: Bool = false

  init(contact: Contact? = nil) {
    self.contactToEdit = contact
    _name = State(initialValue: contact?.name ?? "")
    _daysBetweenNotifications = State(initialValue: contact?.daysBetweenNotifications ?? 7)
    _selectedIcon = State(initialValue: contact?.icon ?? .personFill)
    _selectedColor = State(initialValue: contact?.color ?? .gray)
  }

  var body: some View {
    Form {
      Section("newContact.header.contactInformation") {
        TextField("newContact.inputField.name", text: $name)
      }

      Section("newContact.header.contactAppearance") {
        HStack {
          Button {
            showIconPicker = true
          } label: {
            HStack {
              selectedIcon.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
              Text("newContact.header.icon")
                .foregroundStyle(.primary)
              Spacer()
            }
          }
          .buttonStyle(.borderless)

          Button {
            showColorPicker = true
          } label: {
            HStack {
              Circle()
                .frame(width: 28, height: 28)
                .foregroundStyle(selectedColor)
              Text("newContact.header.color")
                .foregroundStyle(.primary)
              Spacer()
            }
          }
          .buttonStyle(.borderless)
        }
      }

      Section("newContact.header.checkInFrequency") {
        Picker("newContact.checkInFrequency.picker", selection: $daysBetweenNotifications) {
          ForEach(1...90, id: \.self) { day in
            Text("newContact.checkInFrequency.picker \(day)").tag(day)
          }
        }.pickerStyle(.wheel)
      }
    }
    .navigationTitle(isEditing ? "editContact.title" : "newContact.title")
    .navigationBarTitleDisplayMode(.inline)

    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("button.save", systemImage: "checkmark") { saveContact() }
          .disabled(!isContactValid)
      }
    }

    .sheet(isPresented: $showIconPicker) {
      IconPickerSheet(selectedIcon: $selectedIcon)
        .presentationDetents([.medium, .large])
    }

    .sheet(isPresented: $showColorPicker) {
      ColorPickerSheet(selectedColor: $selectedColor)
        .presentationDetents([.fraction(0.3)])
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
      color: selectedColor,
      modelContext: modelContext
    ) {
    case .created, .updated: navigator.back()
    case .updatedWithDaysChanged: showEditAlert = true
    }
  }

  private func createNotification(for contact: Contact) {
    contact.scheduleNextNotification(modelContext: modelContext)
    try? modelContext.save()
  }
}

#Preview("New Contact") { ContactFormView().environment(AppNavigator()) }

#Preview("Edit Contact") {
  @Previewable @State var contact = PreviewData().contact
  ContactFormView(contact: contact).environment(AppNavigator())
}
