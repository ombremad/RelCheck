//
//  RootView.swift
//  RelCheck
//
//  Created by Anne Ferret on 08/12/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigator.self) private var navigator
    
    var body: some View {
        @Bindable var navigator = navigator
        
        if hasCompletedOnboarding {
            NavigationStack(path: $navigator.path) {
                ContactsView()
                    .navigationDestination(for: AppDestination.self) { destination in
                        switch destination {
                            case .fastCheckIn:
                                FastCheckInView()
                            case .contact(let idString):
                                if let contact = fetchContactByID(idString) {
                                    SingleContactView(contact: contact)
                                } else {
                                    Text("error.contactNotFound")
                                }
                        }
                    }
            }
        } else {
            OnboardingView(onComplete: {
                hasCompletedOnboarding = true
            })
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
