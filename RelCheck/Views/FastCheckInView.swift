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
            contact.checkIn(modelContext: modelContext)
        }
        try? modelContext.save()
    }
}

#Preview {
    FastCheckInView()
}
