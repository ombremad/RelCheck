//
//  SingleContactView.swift
//  notifyme
//
//  Created by Anne Ferret on 13/11/2025.
//


import SwiftUI
import SwiftData

@MainActor
struct SingleContactView: View {
    @Environment(AppNavigator.self) private var navigator
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var contact: Contact
    @State private var hasCheckedIn: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: contact.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 34, height: 34)
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading) {
                        Text(contact.name)
                            .font(.headline)
                        Text("singleContact.everyXDays \(contact.name) \(contact.daysBetweenNotifications)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            if hasCheckedIn {
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "checkmark.message.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(maxWidth: 55)
                    HStack {
                        Spacer()
                        Text("singleContact.checkInCompleted")
                            .font(.headline)
                        Spacer()
                    }
                }
                .foregroundStyle(.white)
                .frame(minHeight: 200)
                .listRowBackground(LinearGradient.primary)
            } else {
                VStack(alignment: .center, spacing: 16) {
                    Image(systemName: "questionmark.message.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(LinearGradient.primary)
                        .frame(maxWidth: 55)
                    HStack {
                        Spacer()
                        Text("singleContact.didYouJustCheckInWith \(contact.name)")
                            .font(.headline)
                        Spacer()
                    }
                    Button("button.checkIn") {
                        checkIn()
                    }
                    .buttonStyle(AppButton())
                }
                .frame(minHeight: 200)
            }
            Section {
                VStack(alignment: .leading) {
                    if let nextNotification = contact.nextUpcomingNotification {
                        Text(nextNotification.dateFormatted)
                            .font(.subheadline)
                    } else {
                        Text("singleContact.overdue")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .listRowBackground(LinearGradient.destructive)
                    }
                }
            } header: {
                Label("singleContact.nextCheckIn", systemImage: "calendar")
            }
            Section {
                if contact.checkIns?.isEmpty == true {
                    Text("singleContact.noCheckInsYet \(contact.name)")
                        .font(.subheadline)
                } else {
                    
                    ForEach(contact.checkIns?.reversed() ?? []) { checkIn in
                        Text(checkIn.dateFormatted)
                            .font(.subheadline)
                    }
                }
            } header: {
                Label("singleContact.header.lastCheckIns", systemImage: "ellipsis.message")
            }
        }
        .navigationTitle($contact.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert("singleContact.deleteAlert.title", isPresented: $showDeleteAlert) {
            Button("singleContact.deleteAlert.destructiveButton", role: .destructive) {
                contact.delete(from: modelContext)
                navigator.back()
            }
            Button("singleContact.deleteAlert.dismissButton", role: .cancel) {}
        } message: {
            Text("singleContact.deleteAlert.message")
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("button.delete", systemImage: "trash") {
                    showDeleteAlert = true
                }
                .tint(.red)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigator.navigate(to: .editContact(contact: contact))
                } label: {
                    Label("button.edit", systemImage: "pencil")
                }
            }
        }
    }
    
    private func checkIn() {
        contact.checkIn(modelContext: modelContext)
        try? modelContext.save()
        hasCheckedIn = true
    }
}

#Preview {
    SingleContactView(contact: Contact(
        name: "Anne",
        daysBetweenNotifications: 7
    ))
}
