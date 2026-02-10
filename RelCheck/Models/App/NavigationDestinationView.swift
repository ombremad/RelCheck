//
//  NavigationDestinationView.swift
//  RelCheck
//
//  Created by Anne Ferret on 10/02/2026.
//

import SwiftUI
import SwiftData

struct NavigationDestinationView: View {
    let destination: AppDestination
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        switch destination {
        case .singleContact(let idString):
            if let contact = fetchContactByID(idString) {
                SingleContactView(contact: contact)
            } else {
                Text("error.contactNotFound")
            }
        case .about: AboutView()
        case .editContact(let contact): ContactFormView(contact: contact)
        case .fastCheckIn: FastCheckInView()
        case .newContact: ContactFormView()
        case .settings: SettingsView()
        }
    }
    
    @MainActor
    private func fetchContactByID(_ idString: String) -> Contact? {
        guard let uuid = UUID(uuidString: idString) else { return nil }
        
        let descriptor = FetchDescriptor<Contact>(
            predicate: #Predicate { $0.id == uuid }
        )
        return try? modelContext.fetch(descriptor).first
    }
}
